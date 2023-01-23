//
//  SearchBuilder.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 18/1/23
//

import UIKit
// MARK: - SearchBuilder
final class SearchBuilder {
    static func build(factory: NavigationFactory) -> UINavigationController {
        let apiManager = APIManager()
        let viewModel = ViewModel(apiManager: apiManager, coreDataManager: CoreDataManager.shared)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        viewModel.searchView  = viewController
        viewController.viewModel = viewModel
        return factory(viewController)
    }
}

