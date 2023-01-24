//
//  ViewModelDelegate.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation
//MARK: - ViewModelDelegate
protocol ViewModelDelegate: AnyObject {
    var books: [Book] { get }
    var favoriteBooks: [BookCoreData] { get }
    var filteredFavoriteBooks: [BookCoreData] { get }
    var isSearchBarEmpty: Bool { get }
    var isSearching: Bool { get }
    
    func getListBook(withQuery text: String)
    func getListFavoriteBook(withQuery text: String)
    func isPressedSearchSegmentedControl()
    func isPressedFavoriteSegmentedControl()
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool)
    func isEmptyTextSearchBar()
}
