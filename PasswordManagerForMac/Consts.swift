//
//  Const.swift
//  PasswordManager
//
//  Created by 倉知諒 on 2017/04/21.
//  Copyright © 2017年 R.Kurachi. All rights reserved.
//
import Cocoa
class Consts {
    static let APLLINAME: String = NSLocalizedString("aplli_name", comment: "")
//    static let APLLINAME: String = "使いやすい！パスワード管理帳"
    static let PASSCODE_LENGTH: Int = 4

    //-------
    static let ADMOB_APPLICATION_ID: String = "ca-app-pub-5418872710464793~7959767462"

    static let ADMOB_UNIT_ID_PASSWORD: String = "ca-app-pub-5418872710464793/7820166668"
    static let ADMOB_UNIT_ID_LIST: String = "ca-app-pub-5418872710464793/8588297428"
    static let ADMOB_UNIT_ID_EDIT: String = "ca-app-pub-5418872710464793/6058159392"
    static let ADMOB_UNIT_ID_SETTING: String = "ca-app-pub-5418872710464793/8109607660"
//    static let ADMOB_UNIT_ID_ADD:String = "ca-app-pub-5418872710464793/9889593191"

    static let ADMOB_UNIT_ID_CATEGORY_SETTING: String = "ca-app-pub-5418872710464793/9514053781"
    static let ADMOB_UNIT_ID_BACKUP_RESTORE: String = "ca-app-pub-5418872710464793/7888731482"
    static let ADMOB_TEST_DEVICE_ID: String = "0cbf8bcead01a71ff130ac43489c9a14"
    static let ADMOB_TEST_DEVICE_ID_SE2: String = "05db8b8bb003e0b96c0467e6e889d6bd"
    //-------

    static let RAWNAME_NAME: String = NSLocalizedString("account_rawName_name", comment: "")
    static let RAWNAME_ID: String = NSLocalizedString("account_rawName_id", comment: "")
    static let RAWNAME_PASSWORD: String = NSLocalizedString("account_rawName_password", comment: "")
    static let RAWNAME_MAIL: String = NSLocalizedString("account_rawName_mail", comment: "")
    static let RAWNAME_MEMO: String = NSLocalizedString("account_rawName_memo", comment: "")
    static let RAWNAME_CATEGORY: String = NSLocalizedString("account_rawName_category", comment: "")

//    static let RAWNAME_NAME: String = "名前"
//    static let RAWNAME_ID: String = "ID"
//    static let RAWNAME_PASSWORD: String = "パスワード"
//    static let RAWNAME_MAIL: String = "メール"
//    static let RAWNAME_MEMO: String = "メモ"
//    static let RAWNAME_CATEGORY: String = "カテゴリー"

    static let CONTROLCOLOR: NSColor = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)

    static let BACKGROUND_KEY_IMAGE: String = "background_list"

    static let CATEGORY_WEBSITE_IMAGE: String = "category_website"
    static let CATEGORY_MAIL_IMAGE: String = "category_mail"
    static let CATEGORY_GAME_IMAGE: String = "category_game"
    static let CATEGORY_SNS_IMAGE: String = "category_sns"
    static let CATEGORY_WORK_IMAGE: String = "category_work"
    static let CATEGORY_OTHER_IMAGE: String = "category_other"
    static let CATEGORY_EDUCATION_IMAGE: String = "category_education"
    static let CATEGORY_WIFI_IMAGE: String = "category_wifi"
    static let CATEGORY_WEBSITE2_IMAGE: String = "category_website2"
    static let CATEGORY_EDUCATION2_IMAGE: String = "category_education2"
    static let CATEGORY_SNS2_IMAGE: String = "category_sns2"
    static let CATEGORY_ALL_IMAGE: String = "category_all"
    static let CATEGORY_WEBSITE3_IMAGE: String = "category_website3"
    static let CATEGORY_MAIL2_IMAGE: String = "category_mail2"
    static let CATEGORY_GAME2_IMAGE: String = "category_game2"
    static let CATEGORY_SNS3_IMAGE: String = "category_sns3"
    static let CATEGORY_WORK2_IMAGE: String = "category_work2"
    static let CATEGORY_OTHER2_IMAGE: String = "category_other2"
    
    static let CATEGORY_NAME_WEBSITE: String = NSLocalizedString("categoryName_website", comment: "")
    static let CATEGORY_NAME_MAIL: String = NSLocalizedString("categoryName_mail", comment: "")
    static let CATEGORY_NAME_GAME: String = NSLocalizedString("categoryName_game", comment: "")
    static let CATEGORY_NAME_SNS: String = NSLocalizedString("categoryName_sns", comment: "")
    static let CATEGORY_NAME_WORK: String = NSLocalizedString("categoryName_work", comment: "")
    static let CATEGORY_NAME_OTHER: String = NSLocalizedString("categoryName_other", comment: "")
    static let CATEGORY_NAME_EDUCATION: String = NSLocalizedString("categoryName_education", comment: "")
    
//    static let CATEGORY_NAME_WEBSITE: String =      "ウェブサイト"
//    static let CATEGORY_NAME_MAIL: String =         "メール"
//    static let CATEGORY_NAME_GAME: String =         "ゲーム"
//    static let CATEGORY_NAME_SNS: String =          "SNS"
//    static let CATEGORY_NAME_WORK: String =         "仕事"
//    static let CATEGORY_NAME_OTHER: String =        "その他"
//    static let CATEGORY_NAME_EDUCATION: String =    "教育"
    static let CATEGORYNAME = [CATEGORY_NAME_WEBSITE,CATEGORY_NAME_MAIL,CATEGORY_NAME_GAME,CATEGORY_NAME_SNS,CATEGORY_NAME_WORK,CATEGORY_NAME_OTHER]

    static let CHECK_IMAGE: String = "check2"
    static let BACKUP_FORMAT = "・%@：%@\n"
    static let RETURN: String = "\n"
    
    static let TOAST_WHITE_IMAGE:String="toast_white"
    static let TOAST_BLACK_IMAGE:String="toast"
    
    static let DELIMITER: String = "------------------------------------\n"
    static let LEAVEBACKUPCOUNT = 50
    static let images:[Int16:NSImage] = [
        0:  NSImage(named: Consts.CATEGORY_WEBSITE_IMAGE)!
        ,1: NSImage(named: Consts.CATEGORY_MAIL_IMAGE)!
        ,2: NSImage(named: Consts.CATEGORY_GAME_IMAGE)!
        ,3: NSImage(named: Consts.CATEGORY_SNS_IMAGE)!
        ,4: NSImage(named: Consts.CATEGORY_WORK_IMAGE)!
        ,5: NSImage(named: Consts.CATEGORY_OTHER_IMAGE)!
        ,6: NSImage(named: Consts.CATEGORY_EDUCATION_IMAGE)!
        ,7: NSImage(named: Consts.CATEGORY_WIFI_IMAGE)!
        ,8: NSImage(named: Consts.CATEGORY_WEBSITE2_IMAGE)!
        ,9: NSImage(named: Consts.CATEGORY_EDUCATION2_IMAGE)!
        ,10:NSImage(named: Consts.CATEGORY_SNS2_IMAGE)!
        ,11:NSImage(named: Consts.CATEGORY_WEBSITE3_IMAGE)!
        ,12:NSImage(named: Consts.CATEGORY_MAIL2_IMAGE)!
        ,13:NSImage(named: Consts.CATEGORY_GAME2_IMAGE)!
        ,14:NSImage(named: Consts.CATEGORY_SNS3_IMAGE)!
        ,15:NSImage(named: Consts.CATEGORY_WORK2_IMAGE)!
        ,16:NSImage(named: Consts.CATEGORY_OTHER2_IMAGE)!
    ]
    static let CAT_ICON_SIZE = 20
}
