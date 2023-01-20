//
//  SearchTableViewCell.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    var searchTableViewCellViewModel: SearchTableViewCellViewModelDelegate?
   weak var searchVC: SearchVCCellDelegate?
   // var navController: NavController?
    
    
    @IBOutlet weak var previewLink: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var favoritButton: UIButton!
    var isFavorite = false
    var book: Book?
    var bookId = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func reviewBookButton(_ sender: Any) {
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let reviewVC = storyboard.instantiateViewController(withIdentifier: "ReviewVC") as! ReviewVC
     //   navController?.pushViewController(reviewVC, animated: true)
       // searchVC?.isPressedReviewBookButton(idBook: idBook)
    }
    
    @IBAction func isFavoritedButton(_ sender: Any) {
        print(isFavorite)
        isFavorite = !isFavorite
        print(isFavorite)
        let imageButton = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star" )
        favoritButton.setImage(imageButton, for: .normal)
        //searchTableViewCellViewModel?.isPressedFavoritButton()
       // if let book = book {
            searchVC?.isPressedFavoriteButton(bookId: bookId, isFavorite: isFavorite)
      //  }
    }
    
    
    
   // func setup(using book: Book){
    func setup(bookId: String, title: String, author: String, previewLink: String, imageURL: String, isFavorite: Bool) {
        
        bookNameLabel.text = title
        authorNameLabel.text = author
        self.bookId = bookId
        self.previewLink.text = previewLink
        self.isFavorite = isFavorite
        
//        if !isSearching {
//            isFavorite = true
//            let imageButton = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star" )
//            favoritButton.setImage(imageButton, for: .normal)
//        } else {
//            isFavorite = false
//
            let imageButton = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star" )
            favoritButton.setImage(imageButton, for: .normal)
            
//        }
        
        //        try? Books.sharedInstance.getImage(withID: id, { (data) in
        //            DispatchQueue.main.async {
        //                self.bookImage.image = UIImage(data: data)
        //            }
        //        })
        
        //guard let url = book.imageURL else { return }
//        if let url = book.imageURL {
//            DispatchQueue.global().async { [weak self] in
//                if let data = try? Data(contentO) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            bookCoverImage.image = image
//                        }
//                    }
//                }
//            }
//        }
//
//        let url = URL(string: image.url)
//
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            DispatchQueue.main.async {
//                imageView.image = UIImage(data: data!)
//            }
//        }
        
        
        guard  imageURL != "" else {
            if let image = UIImage(named: "noThumb") {
                bookCoverImage.image = image
            }
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: imageURL) else { return }
            let data = try? Data(contentsOf: url)
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.bookCoverImage.image = image
            }
        }
        
    
    
    
        
//        if let stringUrl = book.imageURL{
//
//            let url = URL(string: stringUrl) {
//                DispatchQueue.main.async {
//                    bookCoverImage.image = UIImage(named: <#T##String#>)
//                }
//                anImage.kf.setImage(with: url)
//            }
//        }
    }
}


extension SearchTableViewCell: SearchTableViewCellDelegate {
    
}
