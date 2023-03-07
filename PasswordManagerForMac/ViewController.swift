//
//  ViewController.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/01.
//

import Cocoa


class ViewController: NSViewController,NSTableViewDelegate,NSTableViewDataSource,NSSearchFieldDelegate {
    var accounts: [Account]?
    //    var accounts:[[TestClass]]?
    var sections: [String]?
    var settingKeys:[Int16]?
    var selectedSectionNum: Int?
    var selectedItemNum: Int?
    var settings: [_CategorySetting] = []
    var selectedItem:Int = 0
    
    static var searchText: String? = nil
    static var selectedCategory: _CategorySetting? = nil
    
    @IBOutlet var name: NSTextField!
    @IBOutlet var id: NSTextField!
    @IBOutlet var password: NSTextField!
    @IBOutlet var mail: NSTextField!
    
    @IBOutlet var copied_name: NSTextField!
    @IBOutlet var copied_id: NSTextField!
    @IBOutlet var copied_password: NSTextField!
    @IBOutlet var copied_mail: NSTextField!
    @IBOutlet var copied_apply: NSTextField!
    @IBOutlet var mymenu: NSMenu!
    @IBOutlet weak var tableView: NSTableView!
    //    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var searchBar: NSSearchField!
    //    @IBOutlet weak var searchBarText: NSSearchFieldCell!
    //    @objc dynamic var selectedIndexes = IndexSet()
    @IBOutlet var categoryWidthConstraint: NSLayoutConstraint!
    @IBOutlet var segmentedCell: NSSegmentedCell!
    @IBOutlet var selectedCategoryText: NSTextField!
    @IBOutlet var category: NSSegmentedControl!
    @IBOutlet var memo: NSTextView!
    
    @IBOutlet var applyBtn: NSButton!
    @IBOutlet var deleteBtn: NSButton!
    @IBOutlet var passwordColumn: NSTableColumn!
    @IBOutlet var tableCell_name: NSTextFieldCell!
    //追加ボタン
    @IBAction func touchDown_add(_ sender: Any) {
        print("addaction called")
//        print("test active screen:\(NSApplication.shared.keyWindow)")
        headerClear()
        func dialogOKCancel(question: String, text: String) -> Bool {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = question
            myPopup.informativeText = text
            myPopup.alertStyle = NSAlert.Style.warning
            let textField = NSTextField(frame: NSRect(x:0,y: 0,width:  200,height:  24))
            
            myPopup.accessoryView = textField
            
            myPopup.addButton(withTitle: "OK")
            myPopup.addButton(withTitle: "Cancel")
            let res = myPopup.runModal()
            if res == NSApplication.ModalResponse.alertFirstButtonReturn {
                let name = (myPopup.accessoryView as! NSTextField).stringValue
                print("FirstButton name:\(name)")
                
                //名前は必須
                if(name == "") {
                    showAlert(myTitle: NSLocalizedString("error_sentence3", comment: ""), mySentence: NSLocalizedString("error_title", comment: ""))//名前を入力してください
                    return false
                }
                
                //名前がすでに使用されているかどうかをチェックする
                let account: Account? = Utilities.getAccount(name: name)
                if account != nil {
                    showAlert(myTitle: NSLocalizedString("error_sentence2", comment: ""), mySentence: NSLocalizedString("error_title", comment: ""))//その名前はすでに使用されています
                    return false
                }
                do{
                    let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
                    let viewContext = appDelegate.persistentContainer.viewContext
                    
                    //空行チェック↓
                    //                let query: NSFetchRequest<Account> = Account.fetchRequest()
                    //
                    //                let predicate = NSPredicate(format: "%K = %@", "name", "")
                    //                query.predicate = predicate
                    //                do {
                    //                    let fetchResults = try viewContext.fetch(query)
                    //
                    //                    if(fetchResults.count != 0){
                    //                        print("もう空行ある")
                    //                        return
                    //                    }
                    //                } catch {
                    //                }
                    //add
                    let newaccount = NSEntityDescription.entity(forEntityName: "Account", in: viewContext)
                    let newRecord = NSManagedObject(entity: newaccount!, insertInto: viewContext)
                    newRecord.setValue(name, forKey: "name")
                    appDelegate.saveAction(nil)//TODO 要らない疑惑
                    try viewContext.save()//TODO こっちが必要なものでは？
                }catch{
                    
                }
                //検索条件を消してサーチし直し
                ViewController.searchText = name
                searchBar.stringValue = name
                ViewController.selectedCategory = nil
                
                //セグメントビュー
                category.setSelected(true, forSegment: 0)
                selectedCategoryText.stringValue = String(format: NSLocalizedString("showing_text", comment: ""), arguments: [NSLocalizedString("categoryName_all", comment: "")])
                
                search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
                tableView.selectRowIndexes(NSIndexSet(index: 0) as IndexSet, byExtendingSelection: false)
                setDetail()
                return true
            }
            else if res == NSApplication.ModalResponse.alertSecondButtonReturn{
                print("SecondButton")
                return true
            }
            return false
        }
        let answer = dialogOKCancel(question: NSLocalizedString("confirm_add", comment: ""), text: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerClear()
        //test code
//        testAdd()
//        testCategoryAdd()
        //        search(searchText: nil, category: nil)
    }
    
    //test code
    func testAdd() {
        //全削除
        do{
            let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
            let viewContext = appDelegate.persistentContainer.viewContext
            let request: NSFetchRequest<Account> = Account.fetchRequest()
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
        
        
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        for i in 0..<5 {
            var category = Int16.max
            category = Int16(i)
            //add
            let account = NSEntityDescription.entity(forEntityName: "Account", in: viewContext)
            let newRecord = NSManagedObject(entity: account!, insertInto: viewContext)
            //        newRecord.setValue("\(self.name.text!)", forKey: "name")
            //        newRecord.setValue("\(self.id.text!)", forKey: "id")
            //        newRecord.setValue("\(self.password.text!)", forKey: "password")
            //        newRecord.setValue("\(self.mail.text!)", forKey: "mail")
            //        newRecord.setValue("\(self.memo.text!)", forKey: "memo")
            newRecord.setValue("testname\(i)", forKey: "name")
            newRecord.setValue("1234", forKey: "id")
            newRecord.setValue("dfg**++", forKey: "password")
            newRecord.setValue("hoge@huga.com", forKey: "mail")
            newRecord.setValue("piyo", forKey: "memo")
            newRecord.setValue(category, forKey: "category")
            //        appDelegate.saveContext()
            appDelegate.saveAction(nil)//TODO 要らない疑惑
        }
    }
    
    //test code
    func testCategoryAdd(){
        
        settings.append(_CategorySetting(no: 0, name: "web", imageNo: 0))
        settings.append(_CategorySetting(no: 1, name: "mail", imageNo: 1))
        settings.append(_CategorySetting(no: 2, name: "game", imageNo: 2))
        settings.append(_CategorySetting(no: 3, name: "sns", imageNo: 3))
        settings.append(_CategorySetting(no: 4, name: "work", imageNo: 4))
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
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        print("viewWillAppear")
        initializeSetting()
//        initializeSetting(afterCatEdit: false)
    }
    func initializeSetting() {
        print("initializeSetting called!!")
        if ViewController.searchText != nil {
            searchBar.stringValue = ViewController.searchText!
        }
        if ViewController.selectedCategory != nil {
            category.selectedSegment = Int((ViewController.selectedCategory?.no)!) + 1
        }
        Utilities.refreshSettings()
        setCategorySegment()
        search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
        
        mymenu.removeAllItems()
        //おそらく順番を担保するためのfor(1個目)
        for (index,_) in Utilities.settings.enumerated(){
            for key in Utilities.settings.keys{
                let setting = Utilities.settings[key]
                if index == setting!.no {
                    let item = NSMenuItem()
                    let size = CGSize(width: Consts.CAT_ICON_SIZE,height: Consts.CAT_ICON_SIZE) // 目的のピクセルサイズ
                    guard let cgContext = CGContext(data: nil,
                                                    width: Int(size.width),
                                                    height: Int(size.height),
                                                    bitsPerComponent: 8,
                                                    bytesPerRow: 4 * Int(size.width),
                                                    space: CGColorSpaceCreateDeviceRGB(),
                                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
                    else {
                        return
                    }
                    let cgImage:CGImage = Category(rawValue:setting!.imageNo)!.image().toCGImage
                    cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
                    guard let image = cgContext.makeImage() else { return }
                    item.image = image.toNSImage
                    item.title = setting!.name!
                    item.tag=index
                    mymenu.addItem(item)
                }
            }
        }
        setDetail()
    }
    
    func setDetail() {
        print("setDetail called!!")
        mymenu.performActionForItem(at: 0)
        name.stringValue=""
        id.stringValue=""
        password.stringValue=""
        mail.stringValue=""
        memo.string=""
        if(tableView.selectedRow != -1 && accounts?[tableView.selectedRow] != nil){
            let account:Account = accounts![tableView.selectedRow]
            mymenu.performActionForItem(at: Int(account.category))
            name.stringValue = account.name!
            id.stringValue = (account.id == nil) ? "" : account.id!
            password.stringValue = (account.password == nil) ? "" : account.password!
            mail.stringValue = (account.mail == nil) ? "" : account.mail!
            memo.string = (account.memo == nil) ? "" : account.memo!
        }
    }
    //カテゴリーセグメントの設定
    func setCategorySegment() {
        print("setCategorySegment called")
        segmentedCell.segmentCount = Utilities.settings.count + 1
        print("segments counts :\(Utilities.settings.count + 1)")
//        category.removeAllSegments()
        
//        category.insertSegment(withTitle: NSLocalizedString("categorySegmentAll", comment: ""), at: 0, animated: false)
        segmentedCell.setLabel(NSLocalizedString("categorySegmentAll", comment: ""), forSegment: 0)
        settingKeys = []
        categoryWidthConstraint.constant = CGFloat((Utilities.settings.count + 1) * 50)
        for (index,_) in Utilities.settings.enumerated(){//Utilities.settingsはDictionaryえでありno順に並べる為のfor
            for key in Utilities.settings.keys{
                let setting = Utilities.settings[key]
                if (index == setting!.no){
                    settingKeys?.append(key)
//                    category.insertSegment(withTitle: setting?.name, at: Int(1 + setting!.no), animated: false)
                    let targetIndex = Int(1 + setting!.no)
                    segmentedCell.setLabel((setting?.name)!, forSegment: targetIndex)
                    category.setWidth(50, forSegment: targetIndex)
                }
            }
        }
        settingKeys = settingKeys?.sorted(by:{ (a,b) -> Bool in
            return a < b
        })//多分無駄な処理

        //選択されているカテゴリーを設定する
        if ViewController.selectedCategory == nil{
            category.selectedSegment = 0
        }
        else{
            for (index,key) in (settingKeys?.enumerated())!{
                if (Int(key) == Int(ViewController.selectedCategory!.no)){
                    category.selectedSegment = index + 1
                }
            }
        }
        selectedCategoryText.stringValue = String(format: NSLocalizedString("showing_text", comment: ""), arguments: [NSLocalizedString("categoryName_all", comment: "")])
    }
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int{
        //        if accounts == nil{
        //            return 0
        //        }
        //        var cnt = 0
        //        for account in accounts!{
        //            cnt = cnt + account.count
        //        }
        //        return cnt
        //        return accounts == nil ? 0 : accounts![section].count
        let cnt = accounts == nil ? 0 : accounts!.count
        print("numberOfRows cnt:\(cnt)")
        return cnt
    }
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int){
        print("didAdd called!!")
    }
    func tableViewSelectionDidChange(_ notification: Notification){
        print("tableViewSelectionDidChange called!!")
        deleteBtn.isEnabled = !(self.tableView.selectedRow == -1)
        applyBtn.isEnabled = !(self.tableView.selectedRow == -1)
        if accounts == nil{
            print("accountsなし")
            return
        }
        else if tableView.selectedRow == -1 {
            print("選択なし")
            return
        }
        else if tableView.numberOfRows == 0{
            print("行なし")
            return
        }
        setDetail()
    }
    func headerClear()  {
//        let catname = [Consts.RAWNAME_CATEGORY,Consts.RAWNAME_NAME,Consts.RAWNAME_ID,Consts.RAWNAME_PASSWORD,Consts.RAWNAME_MAIL,Consts.RAWNAME_MEMO]
//        for (i,col) in tableView.tableColumns.enumerated(){
//            col.headerCell.stringValue=catname[i]
//        }
//        tableView.reloadData()
        copied_name.stringValue = ""
        copied_id.stringValue = ""
        copied_password.stringValue = ""
        copied_mail.stringValue = ""
        copied_apply.stringValue = ""
    }
    func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn){
        print("mouseDownInHeaderOf")
    }
    //テーブルに値設定
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        if accounts == nil{
            print("accountsなし")
            return nil
        }
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_category") {
            if accounts![row].category != Int16.max{
                return mymenu.items[Int(accounts![row].category)].image
            }
            else{
                return NSImage()
            }
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_name") {
            return accounts![row].name;
        }
        return "undef"
    }
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int){
        print("setObjectValue called!!table column id:\(tableColumn?.identifier),object:\(object)")
        let ac:Account = accounts![tableView.selectedRow]
        
        var name = ac.name
        var id = ac.id
        var password = ac.password
        var mail = ac.mail
        var memo = ac.memo
        var category = ac.category
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_category") {
            category = object as! Int16
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_name") {
            name = object as? String
            
            //名前は必須
            if(name == "") {
                showAlert(myTitle:NSLocalizedString("error_sentence3", comment: "") , mySentence: NSLocalizedString("error_title", comment: ""))//名前を入力してください
                return
            }
            
            //名前がすでに使用されているかどうかをチェックする
            let account: Account? = Utilities.getAccount(name: name!)
            if account != nil {
                showAlert(myTitle: NSLocalizedString("error_sentence2", comment: ""), mySentence: NSLocalizedString("error_title", comment: ""))//その名前はすでに使用されています
                return
            }
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_id") {
            id = object as? String
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_password") {
            password = object as? String
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_mail") {
            mail = object as? String
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_memo") {
            memo = object as? String
        }
        print("update name:\(name),id:\(id),password\(password),mail\(mail),memo\(memo),category:\(category)")
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", ac.name!)
        request.predicate = predicate
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                record.setValue(name, forKey: "name")
                record.setValue(id, forKey: "id")
                record.setValue(password, forKey: "password")
                record.setValue(mail, forKey: "mail")
                record.setValue(memo, forKey: "memo")
                record.setValue(category, forKey: "category")
            }
            try viewContext.save()
        } catch {
        }
        search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
    }
    //子でdismissすると謎の圧力でこれが呼ばれる
//    override func dismiss(_ viewController: NSViewController) {
//        print("dismiss called!\(viewController)")
//        dismiss(viewController)
//        initializeSetting()
//    }
    @IBAction func chnageValue_mymenu(_ sender: Any) {
        if((sender as! NSPopUpButton).selectedItem != nil)
        {
            selectedItem = (sender as! NSPopUpButton).selectedItem!.tag
            print("chnageValue_mymenu called!! : \(selectedItem)")
        }
//        mymenu.selectedItem
        
    }
    @IBAction func touchDown_apply(_ sender: Any) {
        let ac:Account = accounts![tableView.selectedRow]
        
        var _name = ac.name
        var _id = ac.id
        var _password = ac.password
        var _mail = ac.mail
        var _memo = ac.memo
        var _category = ac.category
        
            
        _category = Int16(selectedItem)
        
        _name = name.stringValue
            //名前は必須
        if(_name == "") {
                showAlert(myTitle:NSLocalizedString("error_sentence3", comment: "") , mySentence: NSLocalizedString("error_title", comment: ""))//名前を入力してください
                return
            }
            
            //名前がすでに使用されているかどうかをチェックする
        let account: Account? = Utilities.getAccount(name: _name!)
        if account?.name != ac.name && account != nil {
                showAlert(myTitle: NSLocalizedString("error_sentence2", comment: ""), mySentence: NSLocalizedString("error_title", comment: ""))//その名前はすでに使用されています
                return
            }
        _id = id.stringValue
        _password = password.stringValue
        _mail = mail.stringValue
        _memo = memo.string
        print("update name:\(_name),id:\(_id),password\(_password),mail\(_mail),memo\(_memo),category:\(_category)")
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", ac.name!)
        request.predicate = predicate
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                record.setValue(_name, forKey: "name")
                record.setValue(_id, forKey: "id")
                record.setValue(_password, forKey: "password")
                record.setValue(_mail, forKey: "mail")
                record.setValue(_memo, forKey: "memo")
                record.setValue(_category, forKey: "category")
            }
            try viewContext.save()
        } catch {
        }
        copied_apply.stringValue = NSLocalizedString("alertMsg_save", comment: "")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(time:Timer) in self.headerClear()})
        search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
    }
    @IBAction func touchDown_copy_name(_ sender: Any) {
        copied_name.stringValue=NSLocalizedString("alertMsg_copy", comment: "")
        _ = copyBtnTouchDown(text: name.stringValue)
    }
    @IBAction func touchDown_copy_id(_ sender: Any) {
        copied_id.stringValue=NSLocalizedString("alertMsg_copy", comment: "")
        _ = copyBtnTouchDown(text: id.stringValue)
    }
    @IBAction func touchDown_copy_password(_ sender: Any) {
        copied_password.stringValue=NSLocalizedString("alertMsg_copy", comment: "")
        _ = copyBtnTouchDown(text: password.stringValue)
    }
    @IBAction func touchDown_copy_mail(_ sender: Any) {
        copied_mail.stringValue=NSLocalizedString("alertMsg_copy", comment: "")
        _ = copyBtnTouchDown(text: mail.stringValue)
    }
    @IBAction func touchDown_tocategory(_ sender: Any) {
        headerClear()
        performSegue(withIdentifier: "toCustom", sender: self)
//        presentAsModalWindow(ViewController_categoryEditing())
//        present(ViewController_categoryEditing(), animator: nil)
    }
    @IBAction func touchDown_delete(_ sender: Any) {
        if(tableView.selectedRow == -1){
            return;
        }
        
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        let account: Account = self.accounts![tableView.selectedRow]
        func dialogOKCancel(question: String, text: String) -> Bool {
            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = question
            myPopup.informativeText = text
            myPopup.alertStyle = NSAlert.Style.warning
            myPopup.addButton(withTitle: "OK")
            myPopup.addButton(withTitle: "Cancel")
            let res = myPopup.runModal()
            if res == NSApplication.ModalResponse.alertFirstButtonReturn {
                
                let predicate = NSPredicate(format: "name = %@", account.name!)

                request.predicate = predicate
                do {
                    let fetchResults = try viewContext.fetch(request)
                    for result: AnyObject in fetchResults {
                        let record = result as! NSManagedObject
                        viewContext.delete(record)
                    }
                    try viewContext.save()
                    headerClear()
                    initializeSetting()
                } catch {
                }
                return true
            }
            else if res == NSApplication.ModalResponse.alertSecondButtonReturn{
                print("SecondButton")
                return true
            }
            return false
        }
        let answer = dialogOKCancel(question: NSLocalizedString("confirm_title", comment: ""), text: String(format: NSLocalizedString("confirm_sentence_delete", comment: ""), arguments: [account.name!]))
//        settings.remove(at: tableView.selectedRow)
//        tableView.reloadData()
    }
    @IBAction func touchDown_generateBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "toGenerate", sender: nil)
    }
    @IBAction func touchDown_backuplist(_ sender: Any) {self.performSegue(withIdentifier: "toBackupList", sender: nil)
    }
    //遷移する際の処理/
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCustom" {
            let svc = segue.destinationController as! ViewController_categoryEditing
            svc.parentVC = self
            
        }
        else if segue.identifier == "toBackupList" {
            let svc = segue.destinationController as! ViewController_restore
            svc.parentVC = self
            
        }
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
    //検索
    func search(searchText: String?, category: _CategorySetting?) {
        print("search")
        let query: NSFetchRequest<Account> = Account.fetchRequest()
        
        if searchText != nil && category != nil {
            let predicate = NSPredicate(format: "%K CONTAINS[c] %@ AND %K = %d", "name", searchText!, "category", (category?.no)!)
            query.predicate = predicate
        }
        else if searchText != nil && category == nil {
            let predicate = NSPredicate(format: "%K CONTAINS[c] %@", "name", searchText!)
            query.predicate = predicate
        }
        else if searchText == nil && category != nil {
            let predicate = NSPredicate(format: "%K = %d", "category", (category?.no)!)
            query.predicate = predicate
        }
        refreshSectionsAndAccounts(query)
        tableView?.reloadData()
    }
    
    //引数クエリでグローバル変数sectionsおよびaccountsを作り直す
    func refreshSectionsAndAccounts(_ query: NSFetchRequest<Account>) {
        print("refreshSectionsAndAccounts called!!")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortDescriptor]
        query.sortDescriptors = sortDescriptors
        
        accounts = []
        //        var accounts: [Account] = []
        
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        do {
            let fetchResults = try viewContext.fetch(query)
            for result: AnyObject in fetchResults {
                let account = result as! Account
                accounts!.append(account)
                print(String(format: "name:[%@],category:[%d]", account.name!,account.category))
            }
        } catch {
        }
        print("accounts count:\(accounts?.count)")
        //        appendSections (accounts)
        //        appendAccounts (accounts)
    }
    
    
    func searchFieldDidStartSearching(_ sender: NSSearchField){
        print("searchFieldDidStartSearching")
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField){
        print("searchFieldDidEndSearching")
    }
    
    func controlTextDidChange(_ obj: Notification){
        print("controlTextDidChange called!!")
        if obj.object is NSTextField {
            var field:NSTextField = obj.object as! NSTextField
            print("controlTextDidChange searchBarText:\(searchBar.stringValue),obj:\(field.stringValue)")
            if field.identifier == NSUserInterfaceItemIdentifier("search1") {
                print("search1")
                ViewController.searchText = searchBar.stringValue == "" ? nil : searchBar.stringValue
                search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
            }
            setDetail()
            //            else if field.identifier == NSUserInterfaceItemIdentifier("search2") {
            //                print("search2")//test
            //            }
            
//            else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_password") {
//                if accounts![row].password == nil{
//                    return nil
//                }
//                else{
//                    var rtn:String = String(accounts![row].password!.first!);
//                    for _ in 0...accounts![row].password!.utf16.count{
//                        rtn = rtn + "●";
//                    }
//                    return rtn;
//                }
//            }
        }
    }
    func changeCategory(category: _CategorySetting?) {
        ViewController.selectedCategory = category
        search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
    }
    
    
    //コピーボタン押下処理
    func copyBtnTouchDown(text:String) -> Bool  {
//        setStateTextBox()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(time:Timer) in self.headerClear()})
        if text == "" {
            print("テキストが空文字のため終了")
            return false
        }
        self.copyToClipBoard(text: (text))
        return true
    }
    
    func copyToClipBoard(text: String) {
        NSPasteboard.general.clearContents()
         NSPasteboard.general.setString(text, forType: .string)
//        let board = NSPasteboard.general
//        board.setString(text, forType: .string)
//        let format = NSLocalizedString("confirm_sentence_copy_to_clipboard", comment: "")//クリップボードに「%@」をコピーしました
//        let valueArray: [CVarArg] = [text]
//        ViewController_popup.dispText = String(format: format, arguments: valueArray)//ポップアップビューコントローラーにテキストを設定
//        performSegue(withIdentifier: "toPopUp", sender: nil)//ポップアップビューコントローラーを表示
    }
    //カテゴリー値変更イベントハンドラ
    @IBAction func valueChanged(_ sender: Any) {
        print("category value changed called! selected index:\(category.selectedSegment)")
        deleteBtn.isEnabled = !(self.tableView.selectedRow == -1)
        applyBtn.isEnabled = !(self.tableView.selectedRow == -1)
//        let segment: UISegmentedControl = sender as! UISegmentedControl
        //ALL
        if category.selectedSegment == 0{
            changeCategory(category: nil)
            selectedCategoryText.stringValue = String(format: NSLocalizedString("showing_text", comment: ""), arguments: [NSLocalizedString("categoryName_all", comment: "")])
        }
        else{
            let setting = Utilities.settings[settingKeys![category.selectedSegment - 1]]
            changeCategory(category: _CategorySetting(no: setting!.no, name: setting?.name, imageNo: setting!.imageNo))
            selectedCategoryText.stringValue = String(format: NSLocalizedString("showing_text", comment: ""), arguments: [setting!.name!])
        }
        setDetail()
    }
    //引数accountsでグローバル変数sectionsを作り直す
    //※ appendAccountsより前に呼ぶ
    //    func appendSections(_ accounts: [Account]?) {
    //        if accounts == nil {
    //            return
    //        }
    //        sections = []
    //
    //        for account in accounts! {
    //            var exist = false
    //            let newSection = (account.name! as NSString).substring(to: 1).uppercased()
    //            for section in sections! {
    //                if newSection == section {
    //                    exist = true
    //                }
    //            }
    //            if !exist {
    //                sections!.append(newSection)
    //            }
    //        }
    //    }
    
    //引数accountsでグローバル変数accountsを作り直す
    //※ appendSectionsより後に呼ぶ
    //    func appendAccounts(_ _accounts: [Account]?) {
    //        if _accounts == nil {
    //            return
    //        }
    //
    //        accounts = []
    //
    //        for _ in 0..<sections!.count {
    //            accounts!.append([])
    //        }
    //
    //        for account in _accounts! {
    //            var idx: Int?
    //            let targetSection = (account.name! as NSString).substring(to: 1).uppercased()
    //            for i in 0..<sections!.count {
    //                if targetSection == sections![i] {
    //                    idx = i
    //                }
    //            }
    //            accounts![idx!].append(account)
    //        }
    //    }
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        print("textShouldBeginEditing called!!")
//        passwordColumn.width = 60
        return true
    }
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        print("textShouldEndEditing called!!")
//        passwordColumn.width = 30
        //        if obj.object is NSTextField {
        //            var field:NSTableView = obj.object as! NSTableView
        //            if field.identifier == NSUserInterfaceItemIdentifier("search1") {
        //                print("search1")
        //                ViewController.searchText = searchBar.stringValue == "" ? nil : searchBar.stringValue
        //                search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
        //            }
        //        }
        return true
    }
    //    override func controlTextDidEndEditing(_ obj: Notification) {
    //        saveDreams()
    //    }
}
//extention ViewController:searc{
//
//    //サーチバーのテキストが変更される毎に呼ばれる
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        ViewController_list.searchText = searchText == "" ? nil : searchText
//        search(searchText: ViewController_list.searchText, category: ViewController_list.selectedCategory)
//    }
//}
class TestClass{
    var field1:String
    var field2:String
    var field3:String
    init(field1: String, field2: String, field3: String) {
        self.field1 = field1
        self.field2 = field2
        self.field3 = field3
    }
}
