//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Ilnur Mindubayev on 06.02.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: Int64
    @NSManaged public var family: Family?

}

extension Person : Identifiable {

}
