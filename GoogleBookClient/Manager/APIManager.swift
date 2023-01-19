//
//  APIManager.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

protocol APIManagerProtocol {
    func makeRequestWithQuery(withQuery text: String, completion: @escaping ([Book]) -> Void) throws
    
   // func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> Void)
}

final class APIManager {
    
    let booksUrl = "https://www.googleapis.com/books/v1/volumes"
   // let noThumbnail = "http://webmaster.ypsa.org/wp-content/uploads/2012/08/no_thumb.jpg"
    let bookQueryTemplate = [
        URLQueryItem(name: "maxResults", value: "10"),
        URLQueryItem(name: "fields", value: "items(id,volumeInfo(title, authors, imageLinks, previewLink))")
        
    ]
    
  //  let bookImageUrl = "https://books.google.com/books/content"
    //?printsec=frontcover&img=1&source=gbs_api
    let bookImageQueryTemplate = [
        URLQueryItem(name: "printsec", value: "frontcover"),
        URLQueryItem(name: "img", value: "1"),
        URLQueryItem(name: "source", value: "gbs_api")
    ]
    
    var result: [Book]

    init() {
        
        result = []
    }
    
}
extension APIManager: APIManagerProtocol {
    
    
    func makeRequestWithQuery(withQuery text: String, completion: @escaping ([Book]) -> Void) throws {
        let session = URLSession.shared
        
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
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: AnyObject]
                guard let items = json["items"] as! [[String: Any]]? else {
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
                    print(previewLink)
                    
                    
                    let book = Book(title: title, authors: authors, id: id, imageURL: imageURL, previewLink: previewLink)
                    
                    self.result.append(book)
                }
                
            } catch  {
                print("Error thrown: \(error)")
            }
            completion(self.result)
        }).resume()
    }
    
    
    
    
//
//
//    func getImage(withID id: String, _ completion: @escaping (Data)->()) throws {
//        guard let bookUrl = NSURLComponents(string: bookImageUrl) else {
//            throw JSONError.InvalidURL(bookImageUrl)
//        }
//
//        var query = bookImageQueryTemplate
//        query.append(URLQueryItem(name: "id", value: id))
//
//        bookUrl.queryItems = query
//
//        DispatchQueue.global(qos: .utility).async {
//            let data = try? Data(contentsOf: bookUrl.url!)
//            completion(data!)
//        }
//    }
    
    
    
    
    
    
    
    
    
//
//
//
//    static var googleAPIBooks : String = "https://www.googleapis.com/books/v1/volumes?q="
//    static var noThumbnail : String = "http://webmaster.ypsa.org/wp-content/uploads/2012/08/no_thumb.jpg"
//
//    class func makeRequestWithQuery(query:String, completion: @escaping ([Book]) -> Void) {
//        let finalURL = googleAPIBooks + query
//        guard let url = URL(string: finalURL) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if error != nil {
//                print(error!.localizedDescription)
//                completion([])
//            }
//            guard let data = data else {
//                completion([])
//                return
//            }
//
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
//                return
//            }
//
//            guard let items = json?.object(forKey: "items") as? NSArray else {
//                completion([])
//                return
//            }
//
//            var results: [Book] = []
//            for element in items {
//
//                guard let volumeInfo = (element as? NSDictionary)?.object(forKey: "volumeInfo") as? NSDictionary else {
//                    continue
//                }
//
//                let title = volumeInfo.object(forKey: "title") as? String ?? "No title available"
//                let author = (volumeInfo.object(forKey: "authors") as? [String]) ?? ["No author avaialble"]
//                let imageURL = (volumeInfo.object(forKey: "imageLinks") as? NSDictionary)?.object(forKey: "smallThumbnail") as? String ?? noThumbnail
//
//                let book = Book(title: title, authors: author, thumbnailURL: imageURL)
//                results.append(book)
//
//            }
//            completion(results)
//        }.resume()
//    }
}
