//
//  svjListing.swift
//  test
//
//  Created by Qiu, Men Seng on 23.10.23.
//

import SwiftUI

struct svjListing: View {
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
            Button("Delete this listing") {
                showingAlert = true
                let fileManager = FileManager.default
                
                do {
                    var array = try JSONDecoder().decode([Listing].self, from: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")))
                    print("1")
                    if let index = array.firstIndex(of: listing) {
                        array.remove(at: index)
                    }
                    
                    let data = try JSONEncoder().encode(array)
                    print("2")
                    try data.write(to: getDocumentDirectoryPath().appendingPathComponent("output.txt"))
                    print("succ")
                } catch {
                    print("failed to write to file")
                }

                    
                
            }.padding(10).foregroundColor(Color.red).alert(isPresented: $showingAlert) {
                Alert(title: Text("Listing deleted"), dismissButton: .default(Text("Okay")))
            }
        }
    }
}

func getDocumentDirectoryPath() -> URL {
    let arrayPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docDirectoryPath = arrayPaths[0]
    return docDirectoryPath
  }
