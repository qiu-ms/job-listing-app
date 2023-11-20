//
//  jListing.swift
//  test
//
//  Created by Qiu, Men Seng on 22.10.23.
//

import SwiftUI

struct ListingView: View {
    @State var buttonText = ""
    @State private var showingAlert = false
    
    let listing: Listing
    let saved: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            listing.image
            Text(listing.company_name).bold()
            Text(listing.title)
            Text(listing.location)
            Divider()
            List {
                Text(listing.description)
            }.scrollContentBackground(.hidden)
            
            Button(self.buttonText) {
                buttonFunctionality(isSaved: self.saved, listing: self.listing)
                showingAlert = true
            }.padding(10).alert(isPresented: $showingAlert) {
                    Alert(title: Text("Listing saved"), dismissButton: .default(Text("Okay")))
                }
        }.onAppear {
            if saved {
                buttonText = "Delete this listing"
            } else {
                buttonText = "Save this listing"
            }
        }
    }
    
    private func buttonFunctionality(isSaved: Bool, listing: Listing) {
        do {
            var array = try JSONDecoder().decode([Listing].self, from: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")))
            
            if isSaved {
                array.remove(at: array.firstIndex(of: listing)!)
            } else {
                array.append(listing)
            }
            
            let data = try JSONEncoder().encode(array)
            try data.write(to: getDocumentDirectoryPath().appendingPathComponent("output.txt"))
        } catch {
            print("failed to write to file")
        }
    }
}
