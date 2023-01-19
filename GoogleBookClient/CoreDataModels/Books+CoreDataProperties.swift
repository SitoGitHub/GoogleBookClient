//
//  Books+CoreDataProperties.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 20/1/23.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var attribute: String?
    @NSManaged public var id: String?
    @NSManaged public var image_URL: String?
    @NSManaged public var preview_link: String?

}

extension Books : Identifiable {

}
