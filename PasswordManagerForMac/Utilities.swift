//
//  Utilities.swift
//  PasswordManager
//
//  Created by 倉知諒 on 2017/05/18.
//  Copyright © 2017年 R.Kurachi. All rights reserved.
//
import Cocoa
import CoreData

class Utilities {
    static func makeAccountDataText(name: String?, id: String?, password: String?, mail: String?, memo: String?, category: _CategorySetting?) -> String {
        var str: String = ""
        if name != nil && name != "" {
            str += String(format: Consts.BACKUP_FORMAT, arguments: [Consts.RAWNAME_NAME, name!])
        }
        if id != nil && id != "" {
            str += String(format: Consts.BACKUP_FORMAT, arguments: [Consts.RAWNAME_ID, id!])
        }
        if password != nil && password != "" {
            str += String(format: Consts.BACKUP_FORMAT, arguments: [Consts.RAWNAME_PASSWORD, password!])
        }
        if mail != nil && mail != "" {
            str += String(format: Consts.BACKUP_FORMAT, arguments: [Consts.RAWNAME_MAIL, mail!])
        }
        if memo != nil && memo != "" {
            str += String(format: Consts.BACKUP_FORMAT, arguments: [Consts.RAWNAME_MEMO, memo!])
        }
        var valueArray: [CVarArg] = [Consts.RAWNAME_CATEGORY]
        if category == nil {
            valueArray.append(NSLocalizedString("unCategorized", comment: ""))
        }
        else{
            valueArray.append(category!.name!)
        }
        str += String(format: Consts.BACKUP_FORMAT, arguments: valueArray)
        return str
    }
    
    static func getAccount(name: String) -> Account? {
        let query: NSFetchRequest<Account> = Account.fetchRequest()
        query.fetchLimit = 1
        let predicate = NSPredicate(format: "%K = %@", "name", name)
        query.predicate = predicate

        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext

        var account: Account?
        do {
            let fetchResults = try viewContext.fetch(query)

            for result: AnyObject in fetchResults {
                account = result as? Account
            }

        } catch {
        }
        return account
    }
    static func makeBackUpText() -> String {

        let query: NSFetchRequest<Account> = Account.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        query.sortDescriptors = sortDescriptors

        let format = NSLocalizedString("backup_text_header", comment: "")
        let valueArray: [CVarArg] = [Consts.APLLINAME,Utilities.getNowClockString()]

        var str: String = String(format: format, arguments: valueArray)
        str += Consts.RETURN

        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        do {
            let fetchResults = try viewContext.fetch(query)
            for result: AnyObject in fetchResults {
                str += Consts.DELIMITER

                let name: String? = (result.value(forKey: "name") as? String)!
                let id: String? = result.value(forKey: "id") as? String
                let password: String? = result.value(forKey: "password") as? String
                let mail: String? = result.value(forKey: "mail") as? String
                let memo: String? = result.value(forKey: "memo") as? String
                
                var category: _CategorySetting? = nil
                let raw = result.value(forKey: "category") as? Int16
                if raw != Int16.max{
                    let setting = Utilities.settings[raw!]!
//                    category = Category(rawValue: Utilities.settings[raw!]!.imageNo)
                    category = _CategorySetting(no: setting.no, name: setting.name, imageNo: setting.imageNo)
                }
                
                str += Utilities.makeAccountDataText(name: name, id: id, password: password, mail: mail, memo: memo, category: category)
            }
        } catch {
        }
        return str
    }
    static func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let now = Date()
        return formatter.string(from: now)
    }
    static func dateFormatChangeYYYYMMDD(date: Date?) -> String {
        if date == nil {
            return ""
        }
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        return formatter.string(from: date!)
    }
    static func importBackUpText(text:String) -> Int{
        
        let lines =  text.components(separatedBy: Consts.RETURN)
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        let request_cat: NSFetchRequest<CategorySetting> = CategorySetting.fetchRequest()

        
        //バックアップテキスト１行の正規表現
        let valueArray_: [CVarArg] = [Consts.RAWNAME_NAME,Consts.RAWNAME_ID,Consts.RAWNAME_PASSWORD,Consts.RAWNAME_MAIL,Consts.RAWNAME_MEMO,Consts.RAWNAME_CATEGORY]
        let BACKUP_FORMAT_REGEX = String(format: "^・(%@|%@|%@|%@|%@|%@)：(.+)$", arguments: valueArray_)
        let regex = try? NSRegularExpression(pattern: BACKUP_FORMAT_REGEX, options: NSRegularExpression.Options())
        
        var existsCategory = false
        
        //カテゴリーインポート処理　開始
        for line in lines {
            
            var parts:[String] = []
            
            if let result = regex?.firstMatch(in: line as String, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, (line as NSString).length)) {
                for i in 0..<result.numberOfRanges {
                    if let _ = Range(result.range(at: i)) {
                        let tmp = (line as NSString).substring(with: result.range(at: i))
                        //ラインと同じなら入れない
                        if tmp != line{
                            parts.append(tmp)
                        }
                    }
                }
            }
            
            //正規表現にマッチした
            if( parts.count != 0){
                let key = parts[0]
                let val = parts[1]
                if val == ""{
                    continue
                }
                //カテゴリーの行
                if key == Consts.RAWNAME_CATEGORY {
                    existsCategory = true
                    break
                }
            }
        }
        if !existsCategory {
            return 0
        }
        //全削除(アカウント)
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                viewContext.delete(record)
            }
            try viewContext.save()
        } catch {
        }
        //全削除(カテゴリー)
        do {
            let fetchResults = try viewContext.fetch(request_cat)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                viewContext.delete(record)
            }
            try viewContext.save()
        } catch {
        }
        


        var datas = [String : Any]()//1個分のアカウント情報が入る（名前、ID、パスワード、カテゴリー）
        var cnt = 0
        
        //カテゴリーインポート処理　開始
        for line in lines {
            
            var parts:[String] = []
            
            if let result = regex?.firstMatch(in: line as String, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, (line as NSString).length)) {
                for i in 0..<result.numberOfRanges {
                    if let _ = Range(result.range(at: i)) {
                        let tmp = (line as NSString).substring(with: result.range(at: i))
                        //ラインと同じなら入れない
                        if tmp != line{
                            parts.append(tmp)
                        }
                    }
                }
            }
            
            //正規表現にマッチした
            if( parts.count != 0){
                let key = parts[0]
                let val = parts[1]
                if val == ""{
                    continue
                }
                //カテゴリーの行
                if key == Consts.RAWNAME_CATEGORY {
                    
                    let query: NSFetchRequest<CategorySetting> = CategorySetting.fetchRequest()
                    let predicate = NSPredicate(format: "name = %@", val)
                    query.predicate = predicate

                    do {
                        let fetchResults = try viewContext.fetch(query)
                        //名前指定で取得してないならインサートする
                        if fetchResults.count == 0 {
                            let queryTmp: NSFetchRequest<CategorySetting> = CategorySetting.fetchRequest()
                            let fetchResultsTmp = try viewContext.fetch(queryTmp)
                            
                            let setting = NSEntityDescription.entity(forEntityName: "CategorySetting", in: viewContext)
                            let newRecord = NSManagedObject(entity: setting!, insertInto: viewContext)
                            newRecord.setValue(fetchResultsTmp.count, forKey: "no")
                            newRecord.setValue(val, forKey: "name")
                            newRecord.setValue(0, forKey: "imageNo")//イメージはとりあえず全て0番目のものを指定
//                            appDelegate.saveContext()
                            appDelegate.saveAction(nil)//TODO これで合ってる？
                        }
                    }
                    catch {
                    }
                }
            }
        }
        //settingsをリフレッシュする一覧画面のrefreshSettingsメソッド
        Utilities.refreshSettings()
        //カテゴリーインポート処理　終了
        
        //アカウントインポート処理　開始
        for line in lines {

            var parts:[String] = []
            
            if let result = regex?.firstMatch(in: line as String, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, (line as NSString).length)) {
                for i in 0..<result.numberOfRanges {
                    if let _ = Range(result.range(at: i)) {
                        let tmp = (line as NSString).substring(with: result.range(at: i))
                        //ラインと同じなら入れない
                        if tmp != line{
                            parts.append(tmp)
                        }
                    }
                }
            }
            
            //正規表現にマッチした
            if( parts.count != 0){
                let key = parts[0]
                let val = parts[1]
                if val == ""{
                    continue
                }
                if let _ = datas[ self.convertBackuptextToColumnname(backupText: key)]{
                    //キー重複(１個分溜まった)（下記データサンプルの★の位置）
                    
                    //データサンプル
//                    ★使いやすい！パスワード管理帳　バックアップ★
//                    　　　作成日時：2021-08-07 12:27:19
//                    ------------------------------------
//                    ・名前：.st                       // この時点で、
//                    ・ID：abc@gmail.com              // ここの４つの情報が、
//                    ・パスワード：password             // datasに、
//                    ・カテゴリー：web                  // 入っている
//                    ------------------------------------
//                    ・名前：050plus                          //★
//                    ・ID：abc
//                    ・パスワード：pass
//                    ・カテゴリー：web
                    
                    if let _ = datas["name"]{
                        //nameがある
                        
                        //インサート処理
                        let account = NSEntityDescription.entity(forEntityName: "Account", in: viewContext)
                        let newRecord = NSManagedObject(entity: account!, insertInto: viewContext)
                        for data in datas{
                            newRecord.setValue(data.key == "category" ? data.value : "\(data.value)", forKey: "\(data.key)")
                        }
//                        appDelegate.saveContext()
                        appDelegate.saveAction(nil)//TODO これで合ってる？
                        cnt = cnt + 1
                        //初期化
                        datas = [String : Any]()
                        
                        
                        //次の値挿入
                        let importKey:String = self.convertBackuptextToColumnname(backupText: key)
                        let importVal:Any = key == Consts.RAWNAME_CATEGORY ? self.convertBackupcategorytextTodatabasevalue(categoryText: val) : val
                        if(importKey != ""){
                            datas[importKey] = importVal
                        }
                    }
                    else{
                        //nameがなかったら入れない
                    }
                }
                else {
                    //値挿入
                    let importKey:String = self.convertBackuptextToColumnname(backupText: key)
                    let importVal:Any = key == Consts.RAWNAME_CATEGORY ? self.convertBackupcategorytextTodatabasevalue(categoryText: val) : val
                    if(importKey != ""){
                        datas[importKey] = importVal
                    }
                }
            }
            else if let _ = datas["memo"] {
                if line == Consts.DELIMITER.replacingCharacters(in: Consts.DELIMITER.range(of: "\n")!, with: ""){
                    continue
                }
                let valueArray: [CVarArg] = [(datas["memo"] as! NSString),Consts.RETURN, (line as NSString)]
                datas["memo"] = String(format: "%@%@%@", arguments: valueArray)
            }
        }
        //最後の１個
        if(datas.count != 0  ){
            if let _ = datas["name"]{
                //nameがある

                //インサート処理
                let account = NSEntityDescription.entity(forEntityName: "Account", in: viewContext)
                let newRecord = NSManagedObject(entity: account!, insertInto: viewContext)
                for data in datas{
                    newRecord.setValue(data.key == "category" ? data.value : "\(data.value)", forKey: "\(data.key)")
                }
//                appDelegate.saveContext()
                appDelegate.saveAction(nil)//TODO これで合ってる？
                cnt = cnt + 1
            }
        }
        //アカウントインポート処理　終了
        return cnt
    }
    
    //グローバル変数settingsを作り直す
    static func refreshSettings()  {
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        Utilities.settings.removeAll()
        let request: NSFetchRequest<CategorySetting> = CategorySetting.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "no", ascending: true)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let setting = result as! CategorySetting
                Utilities.settings[setting.no] = setting
            }
        } catch {
        }
    }
    
    //変換メソッド
    //バックアップテキストの値の名前→Accountテーブルのカラム名
    static func convertBackuptextToColumnname(backupText:String) -> String {
        switch backupText {
        case Consts.RAWNAME_NAME:
            return "name"
        case Consts.RAWNAME_ID:
            return "id"
        case Consts.RAWNAME_PASSWORD:
            return "password"
        case Consts.RAWNAME_MAIL:
            return "mail"
        case Consts.RAWNAME_MEMO:
            return "memo"
        case Consts.RAWNAME_CATEGORY:
            return "category"
        default:
            return ""
        }
    }
    //変換メソッド
    //バックアップテキストのカテゴリーのテキスト→Account.Categoryの値
    static func convertBackupcategorytextTodatabasevalue(categoryText:String) -> Int {
        for key in Utilities.settings.keys{
            let setting = Utilities.settings[key]
            if(setting!.name == categoryText){
                return Int(setting!.no)
            }
        }
        return Int(Int16.max)
    }
    //変換メソッド
    //イメージNO → イメージ
    static func convertImageNoToImage(imageNo:Int) -> NSImage{
        return [NSImage(named: Consts.CATEGORY_WEBSITE_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_MAIL_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_GAME_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_SNS_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_WORK_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_OTHER_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_EDUCATION_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_WIFI_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_WEBSITE2_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_EDUCATION2_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_SNS2_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_WEBSITE3_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_MAIL2_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_GAME2_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_SNS3_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_WORK2_IMAGE)!
               ,NSImage(named: Consts.CATEGORY_OTHER2_IMAGE)!
            ][imageNo]
    }
    //現在のカテゴリー
    static var settings: [Int16:CategorySetting] = [:]

    //使ってなさそう
//    static func resize(image: NSImage, width: Double) -> NSImage {
//
//        // オリジナル画像のサイズからアスペクト比を計算
//        let aspectScale = image.size.height / image.size.width
//
//        // widthからアスペクト比を元にリサイズ後のサイズを取得
//        let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
//
//        // リサイズ後のUIImageを生成して返却
//        UIGraphicsBeginImageContext(resizedSize)
//        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return resizedImage!
//    }
}
