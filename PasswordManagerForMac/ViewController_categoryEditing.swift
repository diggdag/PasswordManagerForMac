//
//  ViewController_categoryEditing.swift
//  PasswordManagerForMac
//
//  Created by 倉知諒 on 2023/02/11.
//

import Cocoa


class ViewController_categoryEditing: NSViewController,NSTableViewDelegate,NSTableViewDataSource{
    
    @IBOutlet var tableView: NSTableView!
    var preSettings: [_CategorySetting] = []
    var settings: [_CategorySetting] = []
    var receiveImageNo:Int = 0
    var selectedRow:Int = 0
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
//                    item.title = setting!.name!
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
        else if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_delete") {
//            return NSImage(systemSymbolName: "trash.fill", accessibilityDescription: nil)
            return "delete"

//            var btn  = NSButton()
//            btn.image = NSImage(systemSymbolName: "trash.fill", accessibilityDescription: nil)
//            return btn

//            btn.action = Selector("btnAction")

//            var cell = NSButtonCell(imageCell: NSImage(systemSymbolName: "trash.fill", accessibilityDescription: nil))
//            return cell

//            var cell = NSButtonCell(textCell: "delete")
//            return settings[row].name!//test
        }
        return "undef"
    }
    func btnAction()  {
        settings.remove(at: tableView.selectedRow)
        tableView.reloadData()
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
    @IBAction func deleteBtnPush(_ sender: Any) {
        btnAction()
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
                       }
                       tableView.endUpdates()
                       return true
                   }
                   print("failed")
               }
               return false
    }
}
