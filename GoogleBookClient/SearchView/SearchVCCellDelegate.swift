//
//  SearchVCCellDelegate.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 19/1/23.
//

import Foundation

protocol SearchVCCellDelegate: AnyObject {
    func isPressedReviewBookButton(idBook: String)
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool)
    
}
