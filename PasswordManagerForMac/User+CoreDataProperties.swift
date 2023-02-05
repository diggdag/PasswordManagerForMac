//
//  User+CoreDataProperties.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/02.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var usePassword: Bool

}

extension User : Identifiable {

}
