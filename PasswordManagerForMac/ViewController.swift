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
//    var dreams = [Dream]()

    static var searchText: String? = nil
    static var selectedCategory: _CategorySetting? = nil

    @IBOutlet var mymenu: NSMenu!
    @IBOutlet weak var tableView: NSTableView!
//    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var searchBar: NSSearchField!
//    @IBOutlet weak var searchBarText: NSSearchFieldCell!
//    @objc dynamic var selectedIndexes = IndexSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test code
        testAdd()
        testCategoryAdd()
//        search(searchText: nil, category: nil)
    }
    
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
    func testCategoryAdd(){
        
        settings.append(_CategorySetting(no: 0, name: "test_web", imageNo: 0))
        settings.append(_CategorySetting(no: 1, name: "test_game", imageNo: 1))
        settings.append(_CategorySetting(no: 2, name: "test_sns", imageNo: 2))
        settings.append(_CategorySetting(no: 3, name: "test_work", imageNo: 3))
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
        if ViewController.searchText != nil {
            searchBar.stringValue = ViewController.searchText!
        }
//        if ViewController.selectedCategory != nil {
//            category.selectedSegmentIndex = Int((ViewController.selectedCategory?.no)!) + 1
//        }
        Utilities.refreshSettings()
//        setCategorySegment()
        search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
        
        mymenu.removeAllItems()
        for (index,_) in Utilities.settings.enumerated(){
            for key in Utilities.settings.keys{
                let setting = Utilities.settings[key]
                if index == setting!.no {
                    var item = NSMenuItem()
                    item.image = Category(rawValue:setting!.imageNo)!.image()
                    item.title = setting!.name!
                    mymenu.addItem(item)
                    //                    var image = UIImage()
                    //                    if ViewController_category.selectCategory != nil && setting?.name == ViewController_category.selectCategory?.name{
                    //                        image = UIImage(named: Consts.CHECK_IMAGE)!
                    //                    }
                    //                    categories.append(Data_category(
                    //                        categoryImage: ,
                    //                        category: ,
                    //                        check: image))
                    //                    break
                    //                }
                }
            }
        }
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
//        print("tableViewSelectionDidChange called!!")
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
//        let account: Account = accounts![indexPath.section][indexPath.row]
//
//        let cell: TableViewCell_list = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_list") as! TableViewCell_list
//
//        cell.backgroundColor = UIColor.clear
//        cell.contentView.backgroundColor = UIColor.clear
//        return cell
        
        
//        print("objectValueFor called!!row:\(row),column:\(tableColumn?.identifier.rawValue)")
        if accounts == nil{
            print("accountsなし")
            return nil
        }
//        print("row:\(row),tableColumn?.identifier:\(tableColumn?.identifier)")
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_category") {
            if accounts![row].category != Int16.max{
                return accounts![row].category
//                return Category(rawValue:Utilities.settings[ accounts![row].category]!.imageNo)!.image()
            }
            else{
                return 0
            }
//            return accounts![row].category;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_name") {//AutomaticTableColumnIdentifier.0
            return accounts![row].name;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_id") {
            return accounts![row].id;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_password") {
            return accounts![row].password;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_mail") {
            return accounts![row].mail;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_memo") {
            return accounts![row].memo;
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
//        print("controlTextDidChange")
        if obj.object is NSTextField {
            var field:NSTextField = obj.object as! NSTextField
            print("controlTextDidChange searchBarText:\(searchBar.stringValue),obj:\(field.stringValue)")
            if field.identifier == NSUserInterfaceItemIdentifier("search1") {
                print("search1")
                ViewController.searchText = searchBar.stringValue == "" ? nil : searchBar.stringValue
                search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
            }
//            else if field.identifier == NSUserInterfaceItemIdentifier("search2") {
//                print("search2")//test
//            }
        }
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
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        print("textShouldEndEditing called!!")
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
//class Dream : NSObject {
//    @objc dynamic var name : String
//    init(name : String) { self.name = name }
//    override var description : String { return "Dream " + name }
//}
