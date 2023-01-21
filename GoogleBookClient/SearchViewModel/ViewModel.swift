//
//  ViewModel.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation
//MARK: - class ViewModel
final class ViewModel {
    //MARK: - Properties
    var apiManager: APIManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    var books: [Book]
    var deletedBooks: [Book]
    var favoriteBooks: [BookCoreData]
    weak var searchView: SearchVCProtocol?
    
    var isSearching = true
    //MARK: - init
    init(apiManager: APIManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        books = []
        favoriteBooks = []
        deletedBooks = []
    }
    
    //create New Book
    func createNewBook(book: Book) -> BookCoreData {
        let context = coreDataManager.managedObjectContext
        let newBook = BookCoreData(context: context)
        newBook.book_id = book.id
        newBook.author = book.author
        newBook.title = book.title
        newBook.image_URL = book.imageURL
        newBook.preview_link = book.previewLink
        return newBook
    }
    
    //get all favorite books
    func fetchFavoriteBooks () {
        let favoriteBooks = coreDataManager.getFavoriteBooks()
        switch favoriteBooks {
        case.success(let favoriteBooks):
            self.favoriteBooks = favoriteBooks
            
        case .failure(let error):
            print (error)
        }
    }
}
//MARK: - extension ViewModel: ViewModelDelegate
extension ViewModel: ViewModelDelegate {
    
    //get list books with query
    func getListBook(withQuery text: String) {
        searchView?.activityIndicator.startAnimating()
        try? apiManager.makeRequestWithQuery(withQuery: text) { books in
            self.books = books
            for book in self.books {
                let booksCore = self.coreDataManager.getBookWithBookId(bookId: book.id)
                switch booksCore {
                case.success(let booksCore):
                    if booksCore.count > 0 {
                        if let index = books.firstIndex(where: { $0.id == book.id }){
                            self.books[index].isFavorite = true
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.searchView?.searchBar.resignFirstResponder()
                self.searchView?.activityIndicator.stopAnimating()
                self.searchView?.searchTableView.reloadData()
            }
        }
    }
    // show the search screen
    func isPressedSearchSegmentedControl() {
        searchView?.searchBar.isHidden = false
        searchView?.searchBar.text = ""
        searchView?.searchBar.resignFirstResponder()
        isSearching = true
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    //search the favorite screen
    func isPressedFavoriteSegmentedControl() {
        fetchFavoriteBooks()
        searchView?.searchBar.isHidden = true
        isSearching = false
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    // is Pressed Favorite Button
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool) {
        switch isFavorite {
            //if state is Favorite
        case true:
            var book = Book(title: "", authors: "", id: "", imageURL: "", previewLink: "")
            switch isSearching {
            case true:
                if let index = books.firstIndex(where: { $0.id == bookId }){
                    book = books[index]
                    books[index].isFavorite = true
                }
            case false:
                if let deletedBook = deletedBooks.first(where: { $0.id == bookId }){
                    book = deletedBook
                    if let index = books.firstIndex(where: { $0.id == bookId }){
                        book = books[index]
                        books[index].isFavorite = true
                    }
                }
            }
            let booksCore = coreDataManager.getBookWithBookId(bookId: bookId)
            switch booksCore {
            case.success(let booksCore):
                if booksCore.count == 0 {
                    _ = createNewBook(book: book)
                } else {
                    for bookCore in booksCore{
                        bookCore.setValue(book.previewLink, forKey: "preview_link")
                        bookCore.setValue(book.imageURL, forKey: "image_URL")
                        bookCore.setValue(book.title, forKey: "title")
                        bookCore.setValue(book.author, forKey: "author")
                    }
                }
                coreDataManager.saveContext()
            case .failure(let error):
                print(error)
            }
        case false:
            var book = Book(title: "", authors: "", id: "", imageURL: "", previewLink: "")
            let result: Result<Bool, Errors>
            if let favoriteBook = favoriteBooks.first(where: { $0.book_id == bookId }) {
                book.id = favoriteBook.book_id ?? ""
                book.author = favoriteBook.author ?? ""
                book.title = favoriteBook.title ?? ""
                book.imageURL = favoriteBook.image_URL ?? ""
                book.previewLink = favoriteBook.preview_link ?? ""
            }
            result = coreDataManager.deleteBook(bookId: bookId)
            switch result {
            case.success(_):
                deletedBooks.append(book)
                if let index = books.firstIndex(where: { $0.id == book.id }){
                    self.books[index].isFavorite = false
                }
                coreDataManager.saveContext()
            case .failure(let error):
                print(error)
            }
        }
    }
}

