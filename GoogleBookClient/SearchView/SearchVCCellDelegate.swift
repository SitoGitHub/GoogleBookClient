//
//  SearchVCCellDelegate.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 19/1/23.
//

import Foundation
//MARK: - SearchVCCellDelegate
protocol SearchVCCellDelegate: AnyObject {
    func isPressedFavoriteButton(bookId: String, isFavorite: Bool)    
}
