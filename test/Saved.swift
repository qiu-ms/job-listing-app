//
//  Saved.swift
//  test
//
//  Created by Qiu, Men Seng on 22.10.23.
//

import SwiftUI

struct Saved: View {
    @State var savedListings: [Listing]?
    var body: some View {
        if let savedListings = savedListings {
            List {
                ForEach(savedListings, id: \.self){ savedListing in
                    Section {
                        ListingLink(listing: savedListing, saved: true)
                    }
                }
            }.task {
                readData()
            }
        } else {
            Text("No saved listings").onAppear() {
                readData()
            }
        }
    }
    
    private func readData() {
        do {
            savedListings = try JSONDecoder().decode([Listing].self, from: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")))
            try print(String(bytes: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")), encoding: String.Encoding.utf8))
        } catch {
            print("rip read")
        }
    }
}
