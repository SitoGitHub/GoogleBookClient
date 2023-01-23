//
//  ParsBooks.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 23/1/23.
//

import Foundation


// MARK: - ParsBooks
struct ParsBooks: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String
    let imageLinks: ImageLinks
    let previewLink: String
    let authors: [String]?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail: String
}

