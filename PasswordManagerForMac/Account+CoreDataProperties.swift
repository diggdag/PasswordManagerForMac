//
//  Account+CoreDataProperties.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/02.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var category: Int16
    @NSManaged public var id: String?
    @NSManaged public var mail: String?
    @NSManaged public var memo: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?

}

extension Account : Identifiable {

}
