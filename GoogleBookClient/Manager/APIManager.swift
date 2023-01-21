//
//  APIManager.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation
// MARK: - APIManagerProtocol
protocol APIManagerProtocol {
    func makeRequestWithQuery(withQuery text: String, completion: @escaping ([Book]) -> Void) throws
}
// MARK: - class APIManager
final class APIManager {
    // MARK: - Properties
    let booksUrl = "https://www.googleapis.com/books/v1/volumes"
    let bookQueryTemplate = [
        URLQueryItem(name: "maxResults", value: "10"),
        URLQueryItem(name: "fields", value: "items(id,volumeInfo(title, authors, imageLinks, previewLink))")
    ]
    let bookImageQueryTemplate = [
        URLQueryItem(name: "printsec", value: "frontcover"),
        URLQueryItem(name: "img", value: "1"),
        URLQueryItem(name: "source", value: "gbs_api")
    ]
    var result: [Book]
    // MARK: - Init
    init() {
        result = []
    }
}
// MARK: - extension APIManager
extension APIManager: APIManagerProtocol {
    
    //make Request With Query
    func makeRequestWithQuery(withQuery text: String, completion: @escaping ([Book]) -> Void) throws {
        let session = URLSession.shared
        result = []
        
        // Generate the query for this text
        var query = bookQueryTemplate
        query.append(URLQueryItem(name: "q", value: text))
        
        guard let booksUrl = NSURLComponents(string: booksUrl) else {
            throw JSONError.InvalidURL(booksUrl)
        }
        booksUrl.queryItems = query
        
        // Generate the query url from the query items
        guard let url = booksUrl.url else {
            throw JSONError.InvalidData //????
        }
        
        session.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            do {
                guard let data = data else { return }
                let json = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject]
                guard let items = json?["items"] as! [[String: Any]]? else {
                    throw JSONError.InvalidArray("items")
                }
                self.result = []
                
                for item in items {
                    guard let id = item["id"] as! String? else {
                        throw JSONError.InvalidKey("id")
                    }
                    guard let volumeInfo = item["volumeInfo"] as! [String: AnyObject]? else {
                        throw JSONError.InvalidKey("volumeInfo")
                    }
                    let title = volumeInfo["title"] as? String ?? "Title not available"
                    var authors = "No author information"
                    if let authorsArray = volumeInfo["authors"] as! [String]? {
                        authors = authorsArray.joined(separator: ", ")
                    }
                    let imageURL = (volumeInfo["imageLinks"] as? NSDictionary)?.object(forKey: "smallThumbnail") as? String ?? ""
                    let previewLink = volumeInfo["previewLink"] as? String ?? "No preview link"
                    
                    let book = Book(title: title, authors: authors, id: id, imageURL: imageURL, previewLink: previewLink)
                    self.result.append(book)
                }
            } catch  {
                print("Error thrown: \(error)")
            }
            completion(self.result)
        }).resume()
    }
}
