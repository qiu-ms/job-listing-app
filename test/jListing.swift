//
//  jListing.swift
//  test
//
//  Created by Qiu, Men Seng on 22.10.23.
//

import SwiftUI

struct jListing: View {
    let listing: Listing
    @State private var showingAlert = false
    var body: some View {
        VStack(spacing: 20) {
            URLImage(urlString: listing.thumbnail ?? "")
            Text(listing.company_name).bold()
            Text(listing.title)
            Text(listing.location)
            Divider()
            List {
                Text(listing.description)
            }.scrollContentBackground(.hidden)
            Button("Save this listing") {
                showingAlert = true
                let fileManager = FileManager.default
                
                do {
                    var array = try JSONDecoder().decode([Listing].self, from: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")))
                    print("1")
                    array.append(listing)
                    let data = try JSONEncoder().encode(array)
                    print("2")
                    try data.write(to: getDocumentDirectoryPath().appendingPathComponent("output.txt"))
                    print("succ")
                } catch {
                    print("failed to write to file")
                }

                    
                
            }.padding(10).alert(isPresented: $showingAlert) {
                Alert(title: Text("Listing saved"), dismissButton: .default(Text("Okay")))
            }
        }
    }
}


