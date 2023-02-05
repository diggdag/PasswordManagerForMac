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

    static var searchText: String? = nil
    static var selectedCategory: _CategorySetting? = nil

    @IBOutlet weak var tableView: NSTableView!
//    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var searchBar: NSSearchField!
//    @IBOutlet weak var searchBarText: NSSearchFieldCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //test code
        testAdd()
        search(searchText: nil, category: nil)
    }
    
    func testAdd() {
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        var category = Int16.max
        //add
        let account = NSEntityDescription.entity(forEntityName: "Account", in: viewContext)
        let newRecord = NSManagedObject(entity: account!, insertInto: viewContext)
//        newRecord.setValue("\(self.name.text!)", forKey: "name")
//        newRecord.setValue("\(self.id.text!)", forKey: "id")
//        newRecord.setValue("\(self.password.text!)", forKey: "password")
//        newRecord.setValue("\(self.mail.text!)", forKey: "mail")
//        newRecord.setValue("\(self.memo.text!)", forKey: "memo")
        newRecord.setValue("testname", forKey: "name")
        newRecord.setValue("1234", forKey: "id")
        newRecord.setValue("dfg**++", forKey: "password")
        newRecord.setValue("hoge@huga.com", forKey: "mail")
        newRecord.setValue("piyo", forKey: "memo")
        newRecord.setValue(category, forKey: "category")
//        appDelegate.saveContext()
        appDelegate.saveAction(nil)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
//        if ViewController_list.searchText != nil {
//            searchBar.text = ViewController_list.searchText
//        }
//        if ViewController_list.selectedCategory != nil {
//            category.selectedSegmentIndex = Int((ViewController_list.selectedCategory?.no)!) + 1
//        }
//        Utilities.refreshSettings()
//        setCategorySegment()
//        search(searchText: ViewController_list.searchText, category: ViewController_list.selectedCategory)
        
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
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        print("objectValueFor called!!")
        if accounts == nil{
            print("accountsなし")
            return nil
        }
        print("row:\(row),tableColumn?.identifier:\(tableColumn?.identifier)")
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("AutomaticTableColumnIdentifier.0") {
            return accounts![row].name;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("AutomaticTableColumnIdentifier.1") {
            return accounts![row].id;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("AutomaticTableColumnIdentifier.2") {
            return accounts![row].password;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("AutomaticTableColumnIdentifier.3") {
            return accounts![row].mail;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("AutomaticTableColumnIdentifier.4") {
            return accounts![row].memo;
        }
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("AutomaticTableColumnIdentifier.5") {
            return accounts![row].category;
        }
        return "undef"
    }
    
    //検索
    func search(searchText: String?, category: _CategorySetting?) {
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
        print("controlTextDidChange searchBarText:\(searchBar.stringValue)")
        ViewController.searchText = searchBar.stringValue == "" ? nil : searchBar.stringValue
        search(searchText: ViewController.searchText, category: ViewController.selectedCategory)
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
