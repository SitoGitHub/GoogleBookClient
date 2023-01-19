//
//  SearchTableViewCellViewModel.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 19/1/23.
//

import Foundation


final class SearchTableViewCellViewModel {
    
    var apiManager: APIManagerProtocol
   // var books: [Book]
    weak var searchTableViewCell: SearchTableViewCellDelegate?
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
        //books = []
    }
}

extension SearchTableViewCellViewModel: SearchTableViewCellViewModelDelegate {
    func isPressedFavoritButton() {
        print("isPressedFavoritButton")
    }
    
    func isPressedReviewBookButton() {
        
    }
}
