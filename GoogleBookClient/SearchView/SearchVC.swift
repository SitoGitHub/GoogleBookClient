//
//  SearchVC.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 17/1/23.
//

import UIKit
//MARK: - class SearchVC
final class SearchVC: UIViewController {
    //MARK: - Properties
    var viewModel: ViewModelDelegate?
    let searchTableViewCell = "SearchTableViewCell"
    var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    @IBOutlet weak var searchTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        setupSearchBar()
        setupSearchTableView()
    }
    //change search and favorite screens
    @IBAction func bookListSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel?.isPressedSearchSegmentedControl()
        case 1:
            viewModel?.isPressedFavoriteSegmentedControl()
        default: break
        }
        
    }
    //setup Search Bar
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    //setup Search TableView
    private func setupSearchTableView() {
        searchTableView.dataSource = self
        searchTableView.keyboardDismissMode = .onDrag
        searchTableView.rowHeight = UITableView.automaticDimension
        //register cell
        let nibCell = UINib(nibName: searchTableViewCell, bundle: nil)
        searchTableView.register(nibCell, forCellReuseIdentifier: searchTableViewCell)
    }
}
//MARK: - extension SearchVC: UITableViewDataSource
extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        guard let isSearching = viewModel?.isSearching else { return numberOfRows }
        switch isSearching {
        case true:
            numberOfRows = viewModel?.books.count ?? 0
        case false:
            guard let isSearchBarEmpty = viewModel?.isSearchBarEmpty else {return numberOfRows}
            if isSearchBarEmpty {
                numberOfRows = viewModel?.favoriteBooks.count ?? 0
            } else {
                numberOfRows = viewModel?.filteredFavoriteBooks.count ?? 0
            }
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewCell, for: indexPath) as! SearchTableViewCell
        cell.searchVC = self
        guard let isSearching = viewModel?.isSearching else { return cell }
        switch isSearching {
        case true:
            if let element = viewModel?.books[indexPath.row] {
                cell.setup(bookId: element.id, title: element.title, author: element.author, previewLink: element.previewLink, imageURL: element.imageURL, isFavorite: element.isFavorite)
            }
        case false:
            var element = BookCoreData()
            if let isSearchBarEmpty = viewModel?.isSearchBarEmpty {
                if isSearchBarEmpty {
                    if let book = viewModel?.favoriteBooks[indexPath.row] {
                        element = book
                    }
                } else {
                    if let book = viewModel?.filteredFavoriteBooks[indexPath.row] {
                        element = book
                    }
                }
                    let bookId = element.book_id ?? ""
                    let title = element.title ?? "Title not available"
                    let author = element.author ?? "No author information"
                    let previewLink = element.preview_link ?? "No preview link"
                    let imageURL = element.image_URL ?? ""
                    
                    cell.setup(bookId: bookId, title: title, author: author, previewLink: previewLink, imageURL: imageURL, isFavorite: true)
               
            }
        }
        return cell
    }
}
//MARK: - extension SearchVC: SearchVCProtocol
extension SearchVC: SearchVCProtocol {

    //show warning message
    func presentWarnMessage(title: String?, descriptionText: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: descriptionText,
                                                preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: nil)
        
        alertController.addAction(okBtn)
        
        self.present(alertController,
                                animated: true,
                                completion: nil)
    }
    
}
//MARK: - extension SearchVC: UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    //search books
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, let isSearching = viewModel?.isSearching else { return }
       
        if isSearching  {
            viewModel?.getListBook(withQuery: searchText)
        }
    }
}
//MARK: - extension SearchVC: UISearchResultsUpdating
extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, let isSearching = viewModel?.isSearching else { return }
        if !isSearching {
            viewModel?.getListFavoriteBook(withQuery: searchText)
        }
        if isSearching, searchText.isEmpty {
            viewModel?.isEmptyTextSearchBar()
        }
    }
}

extension SearchVC: UISearchControllerDelegate {
    
}

//MARK: - extension SearchVC: SearchVCCellDelegate
extension SearchVC: SearchVCCellDelegate {
    //change a book`s favorite status
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool) {
        viewModel?.isPressedFavoriteButton(bookId: bookId, isFavorite: isFavorite)
    }
}

