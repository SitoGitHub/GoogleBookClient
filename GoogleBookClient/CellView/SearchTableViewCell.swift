//
//  SearchTableViewCell.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    var searchTableViewCellViewModel: SearchTableViewCellViewModelDelegate?
   weak var searchVC: SearchVCCellDelegate?
    let imageManager: ImageManagerProtocol = ImageManager()
    
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
        
        let imageButton = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star" )
        favoritButton.setImage(imageButton, for: .normal)
        
        self.bookCoverImage.image = nil
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let image = self?.imageManager.loadImageUsingUrlString(urlString: imageURL)
            DispatchQueue.main.async {
                self?.bookCoverImage.image = image
            }
        }
    }
}


extension SearchTableViewCell: SearchTableViewCellDelegate {
    
}
