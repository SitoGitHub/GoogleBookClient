//
//  Extention TableView.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 25/1/23.
//

import UIKit

extension UITableView {
    
    public func scrollToTop(animated: Bool = false) {
        if numberOfRows(inSection: 0) > 0 {
            scrollToRow(
                at: .init(row: 0, section: 0),
                at: .top,
                animated: animated
            )
        }
    }
}
    


