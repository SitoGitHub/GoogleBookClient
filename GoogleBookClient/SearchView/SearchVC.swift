//
//  SearchVC.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 17/1/23.
//

import UIKit

final class SearchVC: UIViewController {
    
    var viewModel: ViewModelDelegate?
    //let cell = SearchTableViewCell
    
    let searchTableViewCell = "SearchTableViewCell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!

    var isSearching = true
    
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
//        let reviewVC = storyboard?.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
//        navigationController?.pushViewController(reviewVC, animated: true)
        
        //let navController = UINavigationController(rootViewController: self)
        //        navController.pushViewController(reviewVC, animated: true)
    }

    
    private func initialize() {
       // self.title = "Search books"
        
        searchBar.delegate = self
        setupSearchTableView()
    }
    
    @IBAction func bookListSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel?.isPressedSearchSegmentedControl()
            isSearching = true
            print(sender.selectedSegmentIndex)
        case 1:
            viewModel?.isPressedFavoriteSegmentedControl()
            isSearching = false
            print(sender.selectedSegmentIndex)
        default: break
        }
        
    }
    
    private func setupSearchTableView() {
   //     searchTableView.delegate = self
        searchTableView.dataSource = self
        
        //register cell
        let nibCell = UINib(nibName: searchTableViewCell, bundle: nil)
        searchTableView.register(nibCell, forCellReuseIdentifier: searchTableViewCell)
        searchTableView.rowHeight = UITableView.automaticDimension
       // searchTableView.estimatedRowHeight = 300
    }
}

extension SearchVC: SearchVCProtocol {
   
    
    
}

extension SearchVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch isSearching {
        case true:
            numberOfRows = viewModel?.books.count ?? 0
        case false:
            numberOfRows = viewModel?.favoriteBooks.count ?? 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewCell, for: indexPath) as! SearchTableViewCell
        cell.searchVC = self
        cell.searchTableViewCellViewModel = SearchTableViewCellViewModel(apiManager: APIManager(), coreDataManager: CoreDataManager.shared)
        switch isSearching {
        case true:
            if let element = viewModel?.books[indexPath.row] {
                //cell.setupSearchResult(using: element)
                cell.setup(bookId: element.id, title: element.title, author: element.author, previewLink: element.previewLink, imageURL: element.imageURL, isFavorite: element.isFavorite)
           }
   //             else {
//                cell.setup(bookId: "", title: "", author: "", previewLink: "", imageURL: "", isFavorite: false)
//            }
        case false:
            if let element = viewModel?.favoriteBooks[indexPath.row] {
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
//
//extension SearchVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath)
//        else { return }
//        let index = indexPath.row
////        let check = presenter?.didSelectRowAt(index: index)
////        cell.accessoryType = check ?? false ? .checkmark : .none
//    }
//}


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

extension SearchVC: SearchVCCellDelegate {
   
    func isPressedReviewBookButton(idBook: String) {
//        let navController = UINavigationController(rootViewController: self)
//        navController.pushViewController(reviewVC, animated: true)
        print("isPressedReviewBookButton", idBook)
        
        let reviewVC = storyboard?.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
        reviewVC.idBook = idBook
        navigationController?.pushViewController(reviewVC, animated: true)
        
    }
    
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool) {
        viewModel?.isPressedFavoriteButton(bookId: bookId, isFavorite: isFavorite)
        //print("isPressedFavoriteButton")
    }
}

