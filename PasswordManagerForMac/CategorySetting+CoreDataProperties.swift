//
//  CategorySetting+CoreDataProperties.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/02.
//
//

import Foundation
import CoreData


extension CategorySetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategorySetting> {
        return NSFetchRequest<CategorySetting>(entityName: "CategorySetting")
    }

    @NSManaged public var imageNo: Int16
    @NSManaged public var name: String?
    @NSManaged public var no: Int16

}

extension CategorySetting : Identifiable {

}
