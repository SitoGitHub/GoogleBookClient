//
//  BookCoreData+CoreDataProperties.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 20/1/23.
//
//

import Foundation
import CoreData


extension BookCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCoreData> {
        return NSFetchRequest<BookCoreData>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var book_id: String?
    @NSManaged public var image_URL: String?
    @NSManaged public var preview_link: String?
    @NSManaged public var title: String?

}

extension BookCoreData : Identifiable {

}
