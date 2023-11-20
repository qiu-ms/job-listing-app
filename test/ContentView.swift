//
//  ContentView.swift
//  test
//
//  Created by Qiu, Men Seng on 18.10.23.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var listings: [Listing]?
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    List {
                        ForEach(listings ?? [], id: \.self){ listing in
                            Section {
                                ListingLink(listing: listing, saved: false)
                            }
                        }
                    }.navigationTitle("Search").scrollContentBackground(.hidden)
                    
                }.searchable(text: $searchText)
                Section {
                    NavigationLink(destination: Saved()) {
                        Text("Tap to see saved listings")
                    }
                }
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

#Preview {
    ContentView()
}
