//
//  SearchVCProtocol.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import UIKit
//MARK: - SearchVCProtocol
protocol SearchVCProtocol: AnyObject {
    var activityIndicator: UIActivityIndicatorView! { get set }
   // var searchBar: UISearchBar! { get set }
    var searchTableView: UITableView! { get set }
    var searchController: UISearchController { get set }
    
    func presentWarnMessage(title: String?, descriptionText: String?)
}
