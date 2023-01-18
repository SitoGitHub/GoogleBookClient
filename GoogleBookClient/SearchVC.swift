//
//  SearchVC.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 17/1/23.
//

import UIKit

class SearchVC: UIViewController {

    let searchTableViewCell = "SearchTableViewCell"
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var bookListSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //register cell
        let nibCell = UINib(nibName: searchTableViewCell, bundle: nil)
        searchTableView.register(nibCell, forCellReuseIdentifier: searchTableViewCell)
        
        searchTableView.rowHeight = UITableView.automaticDimension
    }

}

extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewCell, for: indexPath) as! SearchTableViewCell
        cell.authorNameLabel.text = "DD"
        cell.bookNameLabel.text = "dfdf"
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


