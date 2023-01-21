//
//  Book.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation
// MARK: - Struct for Book
struct Book {
    var title: String
    var author: String
    var id: String
    var imageURL: String
    var previewLink: String
    var isFavorite: Bool
    
    init(title: String, authors: String, id: String, imageURL: String, previewLink: String) {
        self.title = title
        self.author = authors
        self.imageURL = imageURL
        self.id = id
        self.previewLink = previewLink
        self.isFavorite = false
    }
}

