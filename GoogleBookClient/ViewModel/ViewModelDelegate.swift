//
//  ViewModelDelegate.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    var books: [Book] { get }
    
    func getListBook(withQuery text: String)
}
