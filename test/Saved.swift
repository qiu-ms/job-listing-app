//
//  Saved.swift
//  test
//
//  Created by Qiu, Men Seng on 22.10.23.
//

import SwiftUI

struct Saved: View {
    @State var l: [Listing]?
    var body: some View {
        if let li = l {
            List {
                ForEach(li, id: \.self){ li in
                    NavigationLink(destination: svjListing(listing: li)){
                        VStack (spacing: 10) {
                            URLImage(urlString: li.thumbnail ?? "")
                                .background(Color.gray)
                            Text(li.company_name).padding().bold()
                            Text(li.title).padding()
                            Text(li.location).padding().italic()
                            
                        }.frame(maxWidth: .infinity)
                        Divider()
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
            l = try JSONDecoder().decode([Listing].self, from: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")))
            try print(String(bytes: Data(contentsOf: getDocumentDirectoryPath().appendingPathComponent("output.txt")), encoding: String.Encoding.utf8))
        } catch {
            print("rip read")
        }
    }
}
