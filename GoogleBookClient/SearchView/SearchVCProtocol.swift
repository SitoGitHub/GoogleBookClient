//
//  SearchVCProtocol.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import UIKit

protocol SearchVCProtocol: AnyObject {
    var activityIndicator: UIActivityIndicatorView! { get set }
    var searchBar: UISearchBar! { get set }
    var searchTableView: UITableView! { get set }
    
}
