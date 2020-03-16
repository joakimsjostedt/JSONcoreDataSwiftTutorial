//
//  EmployeeCoreData+CoreDataProperties.swift
//  CoreDataJson
//
//  Created by Joakim Sjöstedt on 2020-03-13.
//  Copyright © 2020 Joakim Sjöstedt. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeCoreData> {
        return NSFetchRequest<EmployeeCoreData>(entityName: "EmployeeCoreData")
    }

    @NSManaged public var date: Date
    @NSManaged public var job: String
    @NSManaged public var name: String
    @NSManaged public var bookRelationship: BookCoreData?

}
