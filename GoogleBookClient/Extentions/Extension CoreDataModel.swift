//
//  Extension CoreDataModel.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 20/1/23.
//
import CoreData


// MARK: - CoreDataManagerProtocol
protocol CoreDataManagerProtocol: AnyObject {
    var managedObjectContext: NSManagedObjectContext { get }
    func saveContext ()
    func getBookWithBookId(bookId: String)  -> Result<[BookCoreData], Errors>
    func deleteBook(bookId: String) -> Result<Bool, Errors>
    func getFavoriteBooks() -> Result<[BookCoreData], Errors>
}
// MARK: - extension CoreDataManager CoreDataManagerProtocol
extension CoreDataManager: CoreDataManagerProtocol {
    
    //get All favorite Books
    func getFavoriteBooks() -> Result<[BookCoreData], Errors> {
        let fetchRequest: NSFetchRequest<BookCoreData> = BookCoreData.fetchRequest()
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadBooksError)
        }
    }
    
    //get Maker with his phone number
    func getBookWithBookId(bookId: String)  -> Result<[BookCoreData], Errors> {
        
        let fetchRequest: NSFetchRequest<BookCoreData> = BookCoreData.fetchRequest()
        let predicateId = NSPredicate(format: "%K == %@", #keyPath(BookCoreData.book_id), bookId)
        fetchRequest.predicate = predicateId
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(Errors.loadBooksError)
        }
    }
    //delete book with book Id
    func deleteBook(bookId: String) -> Result<Bool, Errors> {
        var result = false
        let booksCore = getBookWithBookId(bookId: bookId)
        
        switch booksCore {
        case.success(let booksCore):
            if booksCore.count == 0 {
                return .failure(Errors.loadBooksError)
            } else {
                for book in booksCore {
                    managedObjectContext.delete(book)
                    result = true
                }
            }
            return .success(result)
        case .failure(let error):
            return .failure(error)
        }
    }
}


