//
//  ContentView.swift
//  test
//
//  Created by Qiu, Men Seng on 18.10.23.
//

import SwiftUI
import UIKit

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
        } else {
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .background()
                .onAppear{
                    fetchImage()
                }
        }
    }
    
    private func fetchImage() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        
        task.resume()
    }
}

struct ContentView: View {
    @State private var listings: [Listing]?
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            Form {
                List {
                    ForEach(listings ?? [], id: \.self){ listing in
                        Section {
                            NavigationLink(destination: jListing(listing: listing)){
                                VStack (spacing: 10) {
                                    URLImage(urlString: listing.thumbnail ?? "")
                                        .background(Color.gray)
                                    Text(listing.company_name).padding().bold()
                                    Text(listing.title).padding()
                                    Text(listing.location).padding().italic()
                                    
                                }.frame(maxWidth: .infinity)
                                Divider()
                            }
                        }
                    }
                }.navigationTitle("Search").scrollContentBackground(.hidden)
                Section {
                    NavigationLink(destination: Saved()) {
                        Button("Tap to see saved listings") {
                        }
                    }
                }
            }.searchable(text: $searchText)
        }.onChange(of: searchText) {
            Task {
                do {
                    listings = try await getListings(query: searchText)
                    
                } catch custom_error.invalid_url {
                    print("invalid url")
                } catch custom_error.invalid_data {
                    print("invalid data")
                } catch custom_error.invalid_response {
                    print("invalid response")
                } catch {
                    print("unexpected")
                }
            }
        }
    }
}

func getListings(query: String) async throws -> [Listing] {
    let q = query.replacingOccurrences(of: " ", with: "+")
    let endpoint = "https://serpapi.com/search?engine=google_jobs&q=\(q)&api_key=b6c113642ab075efb2bef6f4d3b9c131ae036d0b70894a4f80e5296c0fa434fa"
    
    guard let url = URL(string: endpoint) else {
        throw custom_error.invalid_url
    }

    let (data, response) = try await URLSession.shared.data(from: url)
    print(String(bytes: data, encoding: String.Encoding.utf8))

    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw custom_error.invalid_response
    }

    do {
        let decoder = JSONDecoder()
        let l = try decoder.decode(Listings.self, from: data)
        let listings = l.jobs_results
        return listings
    } catch {
        print(error)
        throw custom_error.invalid_data
    }

}

struct Listing: Codable, Hashable {
    let title: String
    let company_name: String
    let thumbnail: String?
    let location: String
    let description: String
}

struct Listings: Codable {
    let jobs_results: [Listing]
}

enum custom_error: Error {
    case invalid_url
    case invalid_response
    case invalid_data
}

#Preview {
    ContentView()
}
