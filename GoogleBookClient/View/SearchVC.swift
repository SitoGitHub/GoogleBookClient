//
//  SearchVC.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 17/1/23.
//

import UIKit

final class SearchVC: UIViewController {
    
    var viewModel: ViewModelDelegate?

    let searchTableViewCell = "SearchTableViewCell"
    
    @IBOutlet weak var actitvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var bookListSegmentedControl: UISegmentedControl!
    
//
//    required init?(coder: NSCoder) {
//
//       // viewModel = ViewModel(apiManager: APIManager())
//        super.init(coder: coder)
//      //  viewModel = ViewModel(apiManager: APIManager(), searchView: self)
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }

    
    private func initialize() {
        navigationController?.title = "Search books"
        //actitvityIndicator
        searchBar.delegate = self
        setupSearchTableView()
    }
    
    private func setupSearchTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //register cell
        let nibCell = UINib(nibName: searchTableViewCell, bundle: nil)
        searchTableView.register(nibCell, forCellReuseIdentifier: searchTableViewCell)
        
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 300
    }
}

extension SearchVC: SearchVCProtocol {
    
}

extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.books.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewCell, for: indexPath) as! SearchTableViewCell
       // cell.authorNameLabel.text = "DD"
       // cell.bookNameLabel.text = "dfdf"
        if let element = viewModel?.books[indexPath.row] {
            cell.setup(using: element)
        }
        
        return cell
    }
    
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath)
        else { return }
        let index = indexPath.row
//        let check = presenter?.didSelectRowAt(index: index)
//        cell.accessoryType = check ?? false ? .checkmark : .none
    }
}


extension SearchVC: UISearchBarDelegate {
   
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            viewModel?.getListBook(withQuery: searchText)
        }
    }
}

