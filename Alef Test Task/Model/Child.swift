//
//  Child+CoreDataClass.swift
//  Alef Test Task
//
//  Created by Rostislav on 4/2/21.
//
//

import Foundation
import CoreData

@objc(Child)
public class Child: NSManagedObject {}

extension Child {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Child> {
        return NSFetchRequest<Child>(entityName: "Child")
    }
    @NSManaged public var age: Int16
    @NSManaged public var name: String?
}

extension Child : Identifiable {}
