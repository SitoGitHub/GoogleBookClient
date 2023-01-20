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
    var favoriteBooks: [BookCoreData]
    weak var searchView: SearchVCProtocol?
    
    var isSearching = true
    
    init(apiManager: APIManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        books = []
        favoriteBooks = []
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
    
    //получение общего списка категорий продуктов
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
    
    func getListBook(withQuery text: String) {
        searchView?.activityIndicator.startAnimating()
        try? apiManager.makeRequestWithQuery(withQuery: text) { books in
            DispatchQueue.main.async {
                self.books = books
                self.searchView?.searchTableView.reloadData()
                self.searchView?.searchBar.resignFirstResponder()
                self.searchView?.activityIndicator.stopAnimating()
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
            case true:
                
                var book: Book?
               // var favoriteBook: BookCoreData?
                switch isSearching {
                case true:
                    if let firstBook = books.first(where: { $0.id == bookId }) {
                        book = firstBook
                    }
                case false:
                    if let favoriteBook = favoriteBooks.first(where: { $0.book_id == bookId }) {
                        if let id = favoriteBook.book_id {
                            book?.id = id
                        }
                        if let author = favoriteBook.author {
                            book?.author = author
                        }
                        if let title = favoriteBook.title {
                            book?.title = title
                        }
                        if let url = favoriteBook.image_URL {
                            book?.imageURL = url
                        }
                        if let previewLink = favoriteBook.preview_link {
                            book?.previewLink = previewLink
                        }
                    }
                }
                
                let booksCore = coreDataManager.getBookWithBookId(bookId: bookId)
                switch booksCore {
                case.success(let booksCore):
                    if booksCore.count == 0, let book = book {
                        
                        let newBook = createNewBook(book: book)
                        
                    } else {
                        for bookCore in booksCore{
                            bookCore.setValue(book?.previewLink, forKey: "preview_link")
                            bookCore.setValue(book?.imageURL, forKey: "image_URL")
                            bookCore.setValue(book?.title, forKey: "title")
                            bookCore.setValue(book?.author, forKey: "author")
                        }
                    }
                    coreDataManager.saveContext()
                case .failure(let error):
                    // self.presenter?.fetchedMakerData(maker: nil, error: error)
                    print(error)
                }
                
            case false:
                let result: Result<Bool, Errors>
                
                result = coreDataManager.deleteBook(bookId: bookId)
                switch result {
                case.success(_):
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

