//
//  SearchVCProtocol.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import UIKit

protocol SearchVCProtocol: AnyObject {
    var actitvityIndicator: UIActivityIndicatorView! { get set }
    var searchBar: UISearchBar! { get set }
    var searchTableView: UITableView! { get set }
    var bookListSegmentedControl: UISegmentedControl! { get set }
    
}
