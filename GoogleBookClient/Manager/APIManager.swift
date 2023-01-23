//
//  APIManager.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation
// MARK: - APIManagerProtocol
protocol APIManagerProtocol {
    func makeRequestWithQuery<T: Decodable>(withQuery text: String, completion: @escaping (Result<T, Error>) -> Void)
}
// MARK: - class APIManager
final class APIManager {
    // MARK: - Properties
    let booksUrl = "https://www.googleapis.com/books/v1/volumes"
    let bookQueryTemplate = [
        URLQueryItem(name: "maxResults", value: "10"),
        URLQueryItem(name: "fields", value: "items(id,volumeInfo(title, authors, imageLinks(smallThumbnail), previewLink))")
    ]
    let bookImageQueryTemplate = [
        URLQueryItem(name: "printsec", value: "frontcover"),
        URLQueryItem(name: "img", value: "1"),
        URLQueryItem(name: "source", value: "gbs_api")
    ]
}
// MARK: - extension APIManager
extension APIManager: APIManagerProtocol {
    
    //make Request With Query
    func makeRequestWithQuery<T: Decodable>(withQuery text: String, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession.shared
       
        // Generate the query for this text
        var query = bookQueryTemplate
        query.append(URLQueryItem(name: "q", value: text))
        
        guard let booksUrl = NSURLComponents(string: booksUrl) else {
            completion(.failure(JSONError.InvalidURL(booksUrl)))
            return
        }
        booksUrl.queryItems = query
        
        // Generate the query url from the query items
        guard let url = booksUrl.url else {
            completion(.failure(JSONError.InvalidData))
            return
        }
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(JSONError.InvalidData))
                return
            }
            let decoder = JSONDecoder()
            do {
                let books = try decoder.decode(T.self, from: data)
                completion( Result{books})
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
