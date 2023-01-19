//
//  SearchTableViewCellViewModel.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 19/1/23.
//

import Foundation


final class SearchTableViewCellViewModel {
    
    let coreDataManager: CoreDataManagerProtocol
    var apiManager: APIManagerProtocol
   // var books: [Book]
    weak var searchTableViewCell: SearchTableViewCellDelegate?
    
    init(apiManager: APIManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
        //books = []
    }
}

extension SearchTableViewCellViewModel: SearchTableViewCellViewModelDelegate {
    func isPressedFavoritButton() {
        print("isPressedFavoriteButton")
    }
    
    func isPressedReviewBookButton() {
        
    }
}
