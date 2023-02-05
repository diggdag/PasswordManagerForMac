//
//  _CategorySetting.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/02.
//

class _CategorySetting {
    var no: Int16
    var name: String?
    var imageNo: Int16
    init(no: Int16, name: String?, imageNo: Int16) {
        self.no = no
        self.name = name
        self.imageNo = imageNo
    }
}
