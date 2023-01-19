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
//        let searchTableViewCellStoryboard = UIStoryboard(name: "SearchTableViewCell", bundle: nil)
//        let nibCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
//        let searchTableViewCell = nibCell.instantiate(withOwner: <#T##Any?#>)
//        let searchTableViewCell = storyboard.instantiateViewController(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
//        //let searchTableViewCell = SearchTableViewCell()
//        let navController = NavController()
        let searchTableViewCellViewModel = SearchTableViewCellViewModel(apiManager: apiManager)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        viewModel.searchView  = viewController
        viewController.viewModel = viewModel
//        searchTableViewCell.searchTableViewCellViewModel = searchTableViewCellViewModel
//        searchTableViewCellViewModel.searchTableViewCell = searchTableViewCell
//       // searchTableViewCell.searchVC = viewController
//        searchTableViewCell.navController = navController
        return viewController
    }
}
