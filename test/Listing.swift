//  Listing.swift
//  test
//
//  Created by Qiu, Men Seng on 20.11.23.
//
import Foundation
import SwiftUI

struct Listing: Codable, Hashable {
    let title: String
    let company_name: String
    let thumbnail: String?
    let location: String
    let description: String
    
    var image: URLImage {URLImage(urlString: thumbnail ?? "")}
}
