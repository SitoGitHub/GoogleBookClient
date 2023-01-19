//
//  SearchTableViewCellViewModelDelegate.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 19/1/23.
//

import Foundation

protocol SearchTableViewCellViewModelDelegate: AnyObject {
    func isPressedFavoritButton()
    func isPressedReviewBookButton()
}
