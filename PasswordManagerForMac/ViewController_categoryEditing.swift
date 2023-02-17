//
//  ViewController_categoryEditing.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/11.
//

import Cocoa


class ViewController_categoryEditing: NSViewController,NSTableViewDelegate,NSTableViewDataSource{
    
    @IBOutlet var tableView: NSTableView!
    @IBOutlet var deleteBtn: NSButtonCell!
    var preSettings: [_CategorySetting] = []
    var settings: [_CategorySetting] = []
    var receiveImageNo:Int = 0
    var selectedRow:Int = 0
    var parentVC:ViewController? = nil
    // セルのUTI
    let DRAG_TYPE = "public.data"
    @IBOutlet var mymenu: NSMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        preSettings = []
        settings = []
        let query_: NSFetchRequest<CategorySetting> = CategorySetting.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "no", ascending: true)
        let sortDescriptors = [sortDescriptor]
        query_.sortDescriptors = sortDescriptors

        do {
            let fetchResults = try viewContext.fetch(query_)
            for result: AnyObject in fetchResults {
                let setting = result as! CategorySetting
                settings.append(_CategorySetting(no: setting.no, name: setting.name, imageNo: setting.imageNo))
            }
            preSettings = settings
        } catch {
        }
        
//        tableView.isEditing = true
//        tableView.allowsSelectionDuringEditing = true
//        tableView.dataSource = self
//        tableView.delegate = self
        tableView?.reloadData()
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType(DRAG_TYPE)])
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        initializeSetting()
    }
    func initializeSetting() {
        //リストのメニューの設定
        mymenu.removeAllItems()
        
        //PasswordManager for iOSのカテゴリー選択（コレクションビュー）画面から持ってきたコード
//        Consts.images.count
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell_categoryImage", for: indexPath) as! CollctionViewCell_categoryImage
//
//        cell.setCell(data: Data_catImage(category: Consts.images[Int16(indexPath.row)]!, check: indexPath.row == ViewController_categoryImage.imageNo ? UIImage(named: Consts.CHECK_IMAGE)! : UIImage()))
//        return cell
        
        
        
        for (index,_) in Consts.images.enumerated(){
            for key in Consts.images.keys{
                let image = Consts.images[key]
                if index == key {
                    var item = NSMenuItem()
                    item.image = image
                    item.title = ""
                    mymenu.addItem(item)
                }
            }
        }
    }
    //テーブルに値設定
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        
        
//        let cell: TableViewCell_categoryEditing = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_CategorySetting") as! TableViewCell_categoryEditing
//        cell.setCell(data: Data_categoryEditing(name: , category: Utilities.convertImageNoToImage(imageNo: Int(settings[indexPath.row].imageNo))))
//        return cell
        
        
        
        if preSettings == nil{
            print("カテゴリなし")
            return nil
        }
        //        print("row:\(row),tableColumn?.identifier:\(tableColumn?.identifier)")
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_image") {//AutomaticTableColumnIdentifier.0
            return Int(settings[row].imageNo);
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_category_name") {
            return settings[row].name!
        }
//        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_delete") {
////            return NSImage(systemSymbolName: "trash.fill", accessibilityDescription: nil)
//            return "delete"
//
////            var btn  = NSButton()
////            btn.image = NSImage(systemSymbolName: "trash.fill", accessibilityDescription: nil)
////            return btn
//
////            btn.action = Selector("btnAction")
//
////            var cell = NSButtonCell(imageCell: NSImage(systemSymbolName: "trash.fill", accessibilityDescription: nil))
////            return cell
//
////            var cell = NSButtonCell(textCell: "delete")
////            return settings[row].name!//test
//        }
        return "undef"
    }
    func btnAction()  {
        if(tableView.selectedRow == -1){
            return;
        }
        settings.remove(at: tableView.selectedRow)
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification){
        print("tableViewSelectionDidChange called!!")
        deleteBtn.isEnabled = true
        selectedRow = tableView.selectedRow//消したい
    }
    func numberOfRows(in tableView: NSTableView) -> Int{
        return settings.count
    }
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation{
        if dropOperation == .above {
                    return .move
                }
                return []
    }
    
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int){
        print("setObjectValue called!!table column id:\(tableColumn?.identifier),object:\(object)")
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_image") {
            settings[tableView.selectedRow].imageNo = object as! Int16
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_category_name") {
            var name = object as? String
            //validation start----------------------
            //名前は必須
            if(name == "") {
                showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence3", comment: ""))//名前を入力してください
                return
            }
            //重複した名前がないか
            var duplication = false
            for setting in settings{
                for _setting in settings{
                    if setting.no != _setting.no && setting.name == _setting.name {
                        duplication = true
                    }
                    
                }
            }
            if(duplication) {
                showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence6", comment: ""))//同じ名前があります
                return
            }
            //validation end----------------------
            settings[tableView.selectedRow].name = name
        }
        tableView.reloadData()
    }
//    //ViewController_categoryImageクラスから呼ばれる
//    func setImage(imageNo: Int16,name:String) {
//        settings[selectedRow].imageNo = imageNo
//        settings[selectedRow].name = name
//        tableView.reloadData()
//    }
    @IBAction func touchDown_add(_ sender: Any) {
        settings.insert(_CategorySetting(no: Int16(settings.count), name: "", imageNo: -1), at: settings.count)
        tableView.reloadData()
    }
    @IBAction func touchDown_delete(_ sender: Any) {
        //validation start----------------------
        //カテゴリーが１つ以上存在するか
        if(settings.count == 1) {
            showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence10", comment: ""))//少なくとも１つのカテゴリを作成して下さい
            return
        }
        btnAction()
    }
    @IBAction func touchDown_Done(_ sender: Any) {
        
        //validation start----------------------
        //カテゴリーが１つ以上存在するか
        if(settings.count == 0) {
            showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence8", comment: ""))//少なくとも１つのカテゴリを作成して下さい
            return
        }
        //名前が空白のカテゴリーが存在しないか
        var isEmptyOrNil = false
        for setting in settings{
            if setting.name == "" || setting.name == nil {
                isEmptyOrNil = true
            }
        }
        if(isEmptyOrNil) {
            showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence7", comment: ""))//名前を入力してください
            return
        }
        //重複した名前がないか
        var duplication = false
        for setting in settings{
            for _setting in settings{
                if setting.no != _setting.no && setting.name == _setting.name {
                    duplication = true
                }
                
            }
        }
        if(duplication) {
            showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence6", comment: ""))//同じ名前があります
            return
        }
        //選択していないカテゴリが存在していないか
        var notSelectCategory = false
        for setting in settings{
            if setting.imageNo == -1{
                notSelectCategory = true
            }
        }
        if(notSelectCategory) {
            showAlert(myTitle: NSLocalizedString("error_title", comment: ""), mySentence: NSLocalizedString("error_sentence11", comment: ""))//イメージを選択してください
            return
        }
        //validation end----------------------
        do{
            let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext

            //アカウント（グループごと）
            var accountsInCategory:[[Account]] = []
            for (_,preSetting) in self.preSettings.enumerated(){
                var accounts:[Account] = []
                let request: NSFetchRequest<Account> = Account.fetchRequest()
                let predicate = NSPredicate(format: "%K = %d", "category", preSetting.no)
                request.predicate = predicate
                
                do {
                    let fetchResults = try viewContext.fetch(request)
                    for result: AnyObject in fetchResults {
                        let account = result as! Account
                        accounts.append(account)
                    }
                } catch {
                }
                accountsInCategory.append(accounts)
            }
            
            //アカウントのカテゴリーをアップデート
            for (index, accounts) in accountsInCategory.enumerated(){
                for accoount in accounts{
                    let request: NSFetchRequest<Account> = Account.fetchRequest()
                    let predicate = NSPredicate(format: "name = %@", accoount.name!)
                    request.predicate = predicate
                    do {
                        let fetchResults = try viewContext.fetch(request)
                        for result: AnyObject in fetchResults {//1つ
                        let record = result as! NSManagedObject
                        var cat = 0
                        var exist = false
                        for (_index,setting) in self.settings.enumerated(){//変更後のカテゴリー
                            if setting.no == index{
                                exist = true
                                cat = _index
                                break
                            }
                        }
                        if exist{
                            record.setValue(cat, forKey: "category")
                        }
                        else{
                            //存在しない場合未登録
                            record.setValue(Int16.max, forKey: "category")
                        }
                        }
                        try viewContext.save()
                    } catch {
                    }
                }
            }
            
            
        }
        var name:[String] = []
        var imageNo:[Int] = []
        for setting in self.settings{
            name.append(setting.name!)
            imageNo.append(Int(setting.imageNo))
        }
        //全削除
        do{
            let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<CategorySetting> = CategorySetting.fetchRequest()
            do {
                let fetchResults = try viewContext.fetch(request)
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject
                    viewContext.delete(record)
                }
                try viewContext.save()
            } catch {
            }
        }
        
        //カテゴリ設定テーブルを設定し直す
        do {
            let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext
            //insert
            for (index,_) in self.settings.enumerated(){
                let setting = NSEntityDescription.entity(forEntityName: "CategorySetting", in: viewContext)
                let newRecord = NSManagedObject(entity: setting!, insertInto: viewContext)
                newRecord.setValue(index, forKey: "no")
                newRecord.setValue(name[index], forKey: "name")
                newRecord.setValue(imageNo[index], forKey: "imageNo")
//                appDelegate.saveContext()
                appDelegate.saveAction(nil)
            }
        }
        ViewController.selectedCategory = nil//TODO 移植元も一応こうなっているが...
//        parent?.viewWillAppear()
        parentVC?.viewWillAppear()
        //遷移元の画面に戻る
//        self.pop.navigationController?.popViewController(animated: true)
        self.dismiss(self)
//        self.navigaion
//        self.performSegue(withIdentifier: <#T##NSStoryboardSegue.Identifier#>, sender: <#T##Any?#>)
//        self.
//        dismiss("hoge")
//        initializeSetting()
    }
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool{
        
       // IndexSet の情報を NSPasteboard に保持させる
       let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
       pboard.declareTypes([NSPasteboard.PasteboardType(DRAG_TYPE)], owner: self)
       pboard.setData(data, forType: NSPasteboard.PasteboardType(DRAG_TYPE))
        
       return true
    }
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool{
        
               // NSPasteboard から行の情報を取り出す
               let pasteboard = info.draggingPasteboard
               let pasteboardData = pasteboard.data(forType: NSPasteboard.PasteboardType(DRAG_TYPE))
               if let pasteboardData = pasteboardData {
                   if let rowIndexes = NSKeyedUnarchiver.unarchiveObject(with: pasteboardData) as? IndexSet {
                       tableView.beginUpdates()
                       for oldIndex in rowIndexes {
                           print(oldIndex) // 元の位置
                           print(row) // 移動後の位置
                           var to = row
                           
                           if oldIndex < row {
                               // 要素を下に移動させる場合
                               to = to - 1
                           }
                           let setting = settings[oldIndex]
                           settings.remove(at: oldIndex)
                           settings.insert(setting, at: to)
                           tableView.reloadData()
                           //移動先の行をアクティブにする
                           let indexSet = NSIndexSet(index: to)
                           tableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
                       }
                       tableView.endUpdates()
                       return true
                   }
                   print("failed")
               }
               return false
    }
    //アラートを表示するメソッド
    func showAlert(myTitle: String, mySentence: String) {
        let alert = NSAlert()
        alert.alertStyle = NSAlert.Style.warning
        alert.messageText = mySentence
        alert.informativeText = myTitle
        alert.icon = NSImage(named: NSImage.computerName)
        
        let ok = alert.addButton(withTitle: "Ok")
        ok.image = NSImage(named: NSImage.actionTemplateName)
        ok.imagePosition = NSControl.ImagePosition.imageLeft
        ok.tag = ButtonTag.Ok.rawValue
        
        //            let cancel = alert.addButton(withTitle: "Cancel")
        //            cancel.tag = ButtonTag.Cancel.rawValue
        
        // alert.runModal()
        alert.beginSheetModal(for: self.view.window!, completionHandler: { response in
            switch response.rawValue
            {
            case ButtonTag.Ok.rawValue:
                print("OK")
                break
                //                case ButtonTag.Cancel.rawValue:
                //                    print("Cancel")
                //                    break
            default:
                print("invalid")
            }
        })
    }
}
