//
//  ViewModelDelegate.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    var books: [Book] { get }
    var favoriteBooks: [BookCoreData] { get }
    
    func getListBook(withQuery text: String)
    func isPressedSearchSegmentedControl()
    func isPressedFavoriteSegmentedControl()
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool)
}
