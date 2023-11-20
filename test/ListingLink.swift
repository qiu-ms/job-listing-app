//
//  ListingLink.swift
//  test
//
//  Created by Qiu, Men Seng on 20.11.23.
//

import SwiftUI

struct ListingLink: View {
    let listing: Listing
    let saved: Bool
    var body: some View {
        NavigationLink(destination: ListingView(listing: self.listing, saved: self.saved)){
            VStack (spacing: 10) {
                self.listing.image
                Text(self.listing.company_name).padding().bold()
                Text(self.listing.title).padding()
                Text(self.listing.location).padding().italic()
                
            }.frame(maxWidth: .infinity)
            Divider()
        }
    }
}

