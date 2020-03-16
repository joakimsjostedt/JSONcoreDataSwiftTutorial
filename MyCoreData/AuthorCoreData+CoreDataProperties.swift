//
//  AuthorCoreData+CoreDataProperties.swift
//  CoreDataJson
//
//  Created by Joakim Sjöstedt on 2020-03-13.
//  Copyright © 2020 Joakim Sjöstedt. All rights reserved.
//
//

import Foundation
import CoreData


extension AuthorCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthorCoreData> {
        return NSFetchRequest<AuthorCoreData>(entityName: "AuthorCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var bookRelationship: BookCoreData?

}
