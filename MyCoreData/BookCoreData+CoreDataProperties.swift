//
//  BookCoreData+CoreDataProperties.swift
//  CoreDataJson
//
//  Created by Joakim Sjöstedt on 2020-03-13.
//  Copyright © 2020 Joakim Sjöstedt. All rights reserved.
//
//

import Foundation
import CoreData


extension BookCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCoreData> {
        return NSFetchRequest<BookCoreData>(entityName: "BookCoreData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var authorRelationship: AuthorCoreData?
    @NSManaged public var employeeRelationship: EmployeeCoreData?

}
