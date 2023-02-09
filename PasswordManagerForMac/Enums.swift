//
//  Enums.swift
//  PasswordManager
//
//  Created by 倉知諒 on 2017/05/17.
//  Copyright © 2017年 R.Kurachi. All rights reserved.
//
import Cocoa
enum Screen {
    case list, add, edit, setting, password, category
}
enum ScreenStatus {
    case normal, cameLock, cameCategory
}
enum Category: Int16 {
    case website = 0
    case mail = 1
    case game = 2
    case sns = 3
    case work = 4
    case other = 5
    case education = 6
    case wifi = 7
    case website2 = 8
    case education2 = 9
    case sns2 = 10
    case website3 = 11
    case mail2 = 12
    case game2 = 13
    case sns3 = 14
    case work2 = 15
    case other2 = 16

    func image() -> NSImage {
        Consts.images[self.rawValue]!
    }
    static var enumerate: AnySequence<Category> {
        return AnySequence { () -> AnyIterator<Category> in
            var i: Int16 = -1
            return AnyIterator { () -> Category? in
                {
                    i += 1
                    return Category(rawValue: i)
                }()

            }
        }
    }
}
enum ButtonTag: Int {
    case Ok = 100
    case Cancel = 200
}
