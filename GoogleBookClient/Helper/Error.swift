//
//  Error.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

// MARK: - JSONError
enum JSONError: Error {
    case InvalidURL(String)
    case InvalidKey(String)
    case InvalidArray(String)
    case InvalidData
    case InvalidImage
    case indexOutOfRange
}

// MARK: - CoreDataErrors
public enum Errors: Error {
    case loadBooksError
    case loadCitiesError
    case loadMakersError
    case loadProductsError
    case loadProdactCategoryError
    case incorrectProdactCategoryName
}
