//
//  ViewModel.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import Foundation

final class ViewModel {
    
    var apiManager: APIManagerProtocol
    var books: [Book]
    weak var searchView: SearchVCProtocol?
    
    init(apiManager: APIManagerProtocol) {
   //     self.searchView = SearchVC(coder:)
        self.apiManager = apiManager
        books = []
    }
}

extension ViewModel: ViewModelDelegate {
    
    func getListBook(withQuery text: String){
        searchView?.actitvityIndicator.startAnimating()
        try? apiManager.makeRequestWithQuery(withQuery: text) { books in
            DispatchQueue.main.async {
                self.books = books
                self.searchView?.searchTableView.reloadData()
                self.searchView?.searchBar.resignFirstResponder()
            }
        }
        searchView?.actitvityIndicator.stopAnimating()
    }
}
