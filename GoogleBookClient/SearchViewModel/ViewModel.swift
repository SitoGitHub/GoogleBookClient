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
    weak var searchView: SearchVCProtocol?
    var apiManager: APIManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    var books: [Book]
    var deletedBooks: [Book]
    var favoriteBooks: [BookCoreData]
    var filteredFavoriteBooks: [BookCoreData]
    var placeHolderForSearchTab: String
    var isSearchBarEmpty: Bool {
        return searchView?.searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isSearching = true
    //MARK: - init
    init(apiManager: APIManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        books = []
        favoriteBooks = []
        deletedBooks = []
        filteredFavoriteBooks = []
        placeHolderForSearchTab = ""
    }
    
    //create New Book
    private func createNewBook(book: Book) {
        let context = coreDataManager.managedObjectContext
        let newBook = BookCoreData(context: context)
        newBook.book_id = book.id
        newBook.author = book.author
        newBook.title = book.title
        newBook.image_URL = book.imageURL
        newBook.preview_link = book.previewLink
    }
    //setBooksList from request
    private func setBooksList(items: [Item]) {
        var book = Book(title: "", authors: "", id: "", imageURL: "", previewLink: "")
        for parsBook in items {
            book.id = parsBook.id
            
            book.previewLink = parsBook.volumeInfo.previewLink != "" ? parsBook.volumeInfo.previewLink: "No preview link"
            book.title = parsBook.volumeInfo.title != "" ? parsBook.volumeInfo.title: "Title not available"
            book.imageURL = parsBook.volumeInfo.imageLinks.smallThumbnail
            book.author = parsBook.volumeInfo.authors?.joined(separator: ", ") ?? "No author information"
            self.books.append(book)
        }
    }
    //mark As Favorite Books from request
    private func markAsFavoriteBooks() {
        for book in self.books {
            let booksCore = self.coreDataManager.getBookWithBookId(bookId: book.id)
            switch booksCore {
            case.success(let booksCore):
                if !booksCore.isEmpty {
                    if let index = self.books.firstIndex(where: { $0.id == book.id }){
                        self.books[index].isFavorite = true
                    }
                }
            case .failure(let error):
                switch error {
                case .loadBooksError:
                    self.searchView?.presentWarnMessage(title: "Error database",
                                                        descriptionText: "An error occurred while extracting book`s list")
                default:
                    self.searchView?.presentWarnMessage(title: "Error database",
                                                        descriptionText: "Unexpected error was occurred while deleting book")
                }
            }
        }
    }
    
    //get all favorite books
    private func fetchFavoriteBooks () {
        let favoriteBooks = coreDataManager.getFavoriteBooks()
        switch favoriteBooks {
        case.success(let favoriteBooks):
            self.favoriteBooks = favoriteBooks
            
        case .failure(let error):
            switch error {
            case .loadBooksError:
                searchView?.presentWarnMessage(title: "Error database",
                                               descriptionText: "An error was occurred while extracting favorite book`s list")
            default:
                searchView?.presentWarnMessage(title: "Error database",
                                               descriptionText: "Unexpected error was occurred while extracting favorite book`s list")
            }
        }
    }
}
//MARK: - extension ViewModel: ViewModelDelegate
extension ViewModel: ViewModelDelegate {
    
    //get list books with query
    func getListBook(withQuery text: String) {
        books = []
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
        guard text != "" else {
            self.searchView?.presentWarnMessage(title: "Warning",
                                      descriptionText: "Please enter a text")
            return
        }
        searchView?.activityIndicator.startAnimating()
       
        apiManager.makeRequestWithQuery(withQuery: text) { [weak self] (result: Result<ParsBooks,Error>) in
            switch result {
            case .success(let parsBooks):
                if let items = parsBooks.items {
                    self?.setBooksList(items: items)
                } else {
                    DispatchQueue.main.async {
                        self?.searchView?.presentWarnMessage(title: "",
                                                            descriptionText: "Cannot find something. Try another request")
                    }
                }
                self?.markAsFavoriteBooks()
                
                DispatchQueue.main.async {
                    self?.searchView?.searchController.searchBar.resignFirstResponder()
                    self?.searchView?.activityIndicator.stopAnimating()
                    self?.searchView?.searchTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.searchView?.activityIndicator.stopAnimating()
                    
                    if let error = error as? URLError {
                        switch error.code {
                        case .networkConnectionLost:
                            self?.searchView?.presentWarnMessage(title: "Connection error",
                                                                descriptionText: "Network connection was lost. Please check your internet connection and try your request again")
                        case .notConnectedToInternet:
                            self?.searchView?.presentWarnMessage(title: "Connection error",
                                                                descriptionText: "Please check your internet connection and try your request again")
                        case .timedOut:
                            self?.searchView?.presentWarnMessage(title: "Connection error",
                                                                descriptionText: "The request timed out. Please check your internet connection and try your request again")
                        default:
                            self?.searchView?.presentWarnMessage(title: "Connection Error",
                                                                descriptionText: "Unexpected error was occurred while making request")
                        }
                    } else {
                        print(error)
                    }
                }
            }
        }
    }
    //get list favorite's books with query
    func getListFavoriteBook(withQuery text: String) {
        print(text)
        filterContentForSearchText(text)
        
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFavoriteBooks = favoriteBooks.filter { (book: BookCoreData) -> Bool in
            var result = false
            if let bookAuthor = book.author {
                result = bookAuthor.lowercased().contains(searchText.lowercased())
            }
            if !result, let title = book.title {
                result = title.lowercased().contains(searchText.lowercased())
            }
            return result
      }
      
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    
    // show the search screen
    func isPressedSearchSegmentedControl() {
        searchView?.searchController.searchBar.text = placeHolderForSearchTab
        if isSearchBarEmpty {
            books = []
            DispatchQueue.main.async {
                self.searchView?.searchTableView.reloadData()
            }
        }
        isSearching = true
        searchView?.searchController.searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    //search the favorite screen
    func isPressedFavoriteSegmentedControl() {
        if let text = searchView?.searchController.searchBar.text {
            placeHolderForSearchTab = text
        }
        isSearching = false
        fetchFavoriteBooks()
        searchView?.searchController.searchBar.text = nil
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    
    // reload tableView in the searchTab if is Empty Text SearchBar
    func isEmptyTextSearchBar() {
        books = []
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
                    guard book.id != "" else { return }
                    createNewBook(book: book)
                    if !isSearching, let index = deletedBooks.firstIndex(where: { $0.id == bookId }){
                        deletedBooks.remove(at: index)
                    }
                    
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
                switch error {
                case .loadBooksError:
                    searchView?.presentWarnMessage(title: "Error database",
                                              descriptionText: "An error occurred while adding a book to the favorite book`s list")
                default:
                    self.searchView?.presentWarnMessage(title: "Error database",
                                              descriptionText: "Unexpected error was occurred while adding a book to the favorite book`s list")
                }
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
                switch error {
                case .loadBooksError:
                    searchView?.presentWarnMessage(title: "Error database",
                                              descriptionText: "An error occurred while extracting book`s list")
                default:
                    self.searchView?.presentWarnMessage(title: "Error database",
                                              descriptionText: "Unexpected error was occurred while deleting book")
                }
                if let index = books.firstIndex(where: { $0.id == book.id }){
                    self.books[index].isFavorite = false
                }
            }
        }
    }
}

