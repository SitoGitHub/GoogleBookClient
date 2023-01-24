//
//  SearchTableViewCell.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 18/1/23.
//

import UIKit
//MARK: - class SearchTableViewCell
final class SearchTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var searchVC: SearchVCCellDelegate?
    let imageManager: ImageManagerProtocol = ImageManager()
    
    @IBOutlet weak var previewLinkButton: UIButton!
    @IBOutlet weak var previewLinkTextView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var favoritButton: UIButton!
    var isFavorite = false
    var book: Book?
    var bookId = String()
    var previewLink = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pressPreviewLinkButton(_ sender: Any) {
        guard let url = URL(string: previewLink) else { return }
        UIApplication.shared.open(url)
    }
    //change a book`s favorite status
    @IBAction func isFavoritedButton(_ sender: Any) {
        isFavorite = !isFavorite
        let imageButton = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star" )
        favoritButton.setImage(imageButton, for: .normal)
        searchVC?.isPressedFavoriteButton(bookId: bookId, isFavorite: isFavorite)
    }
    // set cell properties
    func setup(bookId: String, title: String, author: String, previewLink: String, imageURL: String, isFavorite: Bool) {
        
        bookNameLabel.text = title
        authorNameLabel.text = author
        self.bookId = bookId
       // self.previewLinkTextView.text = previewLink
        self.previewLink = previewLink
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

