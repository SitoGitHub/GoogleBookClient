//
//  Book.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

struct Book {
    var title: String?
    var author: String?
    var id: String
    var imageURL: String?
    
    init(title: String, authors: String, id: String, imageURL: String) {
        self.title = title
        self.author = authors
        self.imageURL = imageURL
        self.id = id
    }
}

