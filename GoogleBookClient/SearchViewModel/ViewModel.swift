//
//  ViewModel.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

final class ViewModel {
    
    var apiManager: APIManagerProtocol
    let coreDataManager: CoreDataManagerProtocol
    var books: [Book]
    var deletedBooks: [Book]
    var favoriteBooks: [BookCoreData]
    weak var searchView: SearchVCProtocol?
    
    var isSearching = true
    
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
       // let newBook = NSEntityDescription.insertNewObjectForEntityForName("BookCoreData", inManagedObjectContext: managedObject) as! BookCoreData
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
            //self.presenter?.fetchedProductCategoriesData(productCategories: nil, error: error)
            print (error)
        }
    }
}

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
                    // self.presenter?.fetchedMakerData(maker: nil, error: error)
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.searchView?.searchBar.resignFirstResponder()
                self.searchView?.activityIndicator.stopAnimating()
//                if self.books.count == 0 {
//                    guard let tableView = self.searchView?.searchTableView else { return }
//                    let count = tableView(tableView, numberOfRowsInSection: 0)
//                    // insert action that deletes all your data from the model here
//                    // e.g. self.arrayOfRows = []
//                    self.tableView.deleteRows(at: (0..<count).map({ (i) in IndexPath(row: i, section: 0)}), with: .automatic)
//                }
                self.searchView?.searchTableView.reloadData()
            }
        }
    }
    
    func isPressedSearchSegmentedControl() {
        searchView?.searchBar.isHidden = false
        searchView?.searchBar.text = ""
        searchView?.searchBar.resignFirstResponder()
        isSearching = true
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    func isPressedFavoriteSegmentedControl() {
        fetchFavoriteBooks()
        searchView?.searchBar.isHidden = true
        isSearching = false
        DispatchQueue.main.async {
            self.searchView?.searchTableView.reloadData()
        }
    }
    
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool) {
        print("isPressedFavoriteButton ", isFavorite)
        
        
      //  if let book = books.first(where: { $0.id == bookId }) {
            
        switch isFavorite {
        //if state is Favorite
        case true:
            var book = Book(title: "", authors: "", id: "", imageURL: "", previewLink: "")
           // var favoriteBook: BookCoreData?
            switch isSearching {
            case true:
                if let index = books.firstIndex(where: { $0.id == bookId }){
                    book = books[index]
                    books[index].isFavorite = true
                }
                
            case false:
                if let deletedBook = deletedBooks.first(where: { $0.id == bookId }){
                    book = deletedBook
                }
               // print(books.firstIndex(where: { $0.id == bookId }))
//                if let favoriteBook = favoriteBooks.first(where: { $0.book_id == bookId }) {
////                        if let id = favoriteBook.book_id {
////                            book?.id = id
////                        }
////                        if let author = favoriteBook.author {
////                            book?.author = author
////                        }
////                        if let title = favoriteBook.title {
////                            book?.title = title
////                        }
////                        if let url = favoriteBook.image_URL {
////                            book?.imageURL = url
////                        }
////                        if let previewLink = favoriteBook.preview_link {
////                            book?.previewLink = previewLink
////                        }
//                    print (favoriteBook.book_id)
//                    book.id = favoriteBook.book_id ?? ""
//                    book.author = favoriteBook.author ?? ""
//                    book.title = favoriteBook.title ?? ""
//                    book.imageURL = favoriteBook.image_URL ?? ""
//                    book.previewLink = favoriteBook.preview_link ?? ""
//                    print (book.id)
//                }
            }
                let booksCore = coreDataManager.getBookWithBookId(bookId: bookId)
                switch booksCore {
                case.success(let booksCore):
                    
                    if booksCore.count == 0 {
                        
                        let newBook = createNewBook(book: book)
                        
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
                    // self.presenter?.fetchedMakerData(maker: nil, error: error)
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
                //resultModifyCategory = result
            case .failure(let error):
                // self.presenter?.getErrorWhenFetchedProductCategoriesData(error: error)
                print(error)
            }
            //reWriteMakerAnnotation()
            
                
            }
        //}
    }
}

