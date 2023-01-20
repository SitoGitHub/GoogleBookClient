//
//  SearchBuilder.swift
//  Super easy dev
//
//  Created by Aleksei Grachev on 18/1/23
//

import UIKit

class SearchBuilder {
    static func build(factory: NavigationFactory) -> UINavigationController {
        let apiManager = APIManager()
        let viewModel = ViewModel(apiManager: apiManager, coreDataManager: CoreDataManager.shared) 
//        let searchTableViewCellStoryboard = UIStoryboard(name: "SearchTableViewCell", bundle: nil)
//        let nibCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
//        let searchTableViewCell = nibCell.instantiate(withOwner: <#T##Any?#>)
//        let searchTableViewCell = storyboard.instantiateViewController(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
//        //let searchTableViewCell = SearchTableViewCell()
//        let navController = NavController()
      //  let searchTableViewCellViewModel = SearchTableViewCellViewModel(apiManager: apiManager)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        viewModel.searchView  = viewController
        viewController.viewModel = viewModel
//        searchTableViewCell.searchTableViewCellViewModel = searchTableViewCellViewModel
//        searchTableViewCellViewModel.searchTableViewCell = searchTableViewCell
//       // searchTableViewCell.searchVC = viewController
//        searchTableViewCell.navController = navController
        return factory(viewController)
    }
}


//
//static func build() -> SearchVC {
//    let apiManager = APIManager()
//    let viewModel = ViewModel(apiManager: apiManager)
////        let searchTableViewCellStoryboard = UIStoryboard(name: "SearchTableViewCell", bundle: nil)
////        let nibCell = UINib(nibName: "SearchTableViewCell", bundle: nil)
////        let searchTableViewCell = nibCell.instantiate(withOwner: <#T##Any?#>)
////        let searchTableViewCell = storyboard.instantiateViewController(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
////        //let searchTableViewCell = SearchTableViewCell()
////        let navController = NavController()
//    let searchTableViewCellViewModel = SearchTableViewCellViewModel(apiManager: apiManager)
//
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let viewController = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//    viewModel.searchView  = viewController
//    viewController.viewModel = viewModel
////        searchTableViewCell.searchTableViewCellViewModel = searchTableViewCellViewModel
////        searchTableViewCellViewModel.searchTableViewCell = searchTableViewCell
////       // searchTableViewCell.searchVC = viewController
////        searchTableViewCell.navController = navController
//    return viewController
//}
//}
//
//
////
//
//static func build(factory: NavigationFactory, delegate: RegistrationModuleDelegate?, touchCoordinate: CLLocationCoordinate2D, makerAnotation: MakerAnotation?) ->
//UINavigationController
//{
//    let coreDataManager = CoreDataManager.shared
//    let locationManager = LocationManager()
//    let validData = ValidDataManager()
//    let view = RegistrationViewController()
//    let interactor = RegistrationInteractor(coreDataManager: coreDataManager, locationManager: locationManager)
//    let router = RegistrationRouter()
//    let presenter = RegistrationPresenter(interactor: interactor, router: router, validData: validData, touchCoordinate: touchCoordinate, makerAnotation: makerAnotation)
//    view.presenter = presenter
//    presenter.delegate = delegate
//    presenter.view = view
//    interactor.presenter = presenter
//    router.viewController = view
//    return factory(view)
//}
//}
