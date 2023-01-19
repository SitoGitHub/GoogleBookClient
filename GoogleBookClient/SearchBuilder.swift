//
//  SearchBuilder.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 18/1/23
//

import UIKit

class SearchBuilder {
    static func build() -> SearchVC {
        let apiManager = APIManager()
        let viewModel = ViewModel(apiManager: apiManager)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        viewModel.searchView  = viewController
        viewController.viewModel = viewModel
    
        return viewController
    }
}
