//
//  Backup+CoreDataProperties.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/02.
//
//

import Foundation
import CoreData


extension Backup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Backup> {
        return NSFetchRequest<Backup>(entityName: "Backup")
    }

    @NSManaged public var createDate: Date?
    @NSManaged public var text: String?

}

extension Backup : Identifiable {

}
