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
                TextField("Search", text: $searchText)
                List {
                    ForEach(listings ?? [], id: \.self){ listing in
                        VStack {
                            VStack (spacing: 0) {
                                URLImage(urlString: listing.thumbnail ?? "")
                                    .background(Color.gray)
                                Text(listing.company_name).padding()
                                Text(listing.title).padding()
                                Text(listing.location).padding()
                                Divider()
                            }
                            
                            .padding(3)
                        }
                    }
                }.navigationTitle("Jobs")
            }
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
    let endpoint = "https://serpapi.com/search?engine=google_jobs&q=\(q)&api_key=1be45fa17abaca95a125fa41109f61b1281f3c34c28cf8100e5217a77b4cd576"
    
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
