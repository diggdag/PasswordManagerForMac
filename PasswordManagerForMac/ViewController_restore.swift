//
//  ViewController_restore.swift
//  PasswordManager
//
//  Created by 倉知諒 on 2020/02/13.
//  Copyright © 2020 R.Kurachi. All rights reserved.
//


import Cocoa
import CoreData

class ViewController_restore: NSViewController , NSTableViewDelegate, NSTableViewDataSource{
    @IBOutlet var backup_col: NSTableColumn!
    @IBOutlet weak var tableView: NSTableView!
//    @IBOutlet weak var back: UIView!
//    @IBOutlet weak var dummyView: UIView!
    @IBOutlet var textView: NSTextView!
    var backups: [Backup] = []
    let RADIUS:CGFloat = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController_restore.willEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        backups = []
        let request: NSFetchRequest<Backup> = Backup.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                backups.append(result as! Backup)
            }
        } catch {
        }
//        tableView.dataSource = self
//        tableView.delegate = self
//        view.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        back.layer.cornerRadius = RADIUS
//        dummyView.layer.cornerRadius = RADIUS
//        back.clipsToBounds = true
    }
    
    //テーブルに値設定
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_backup") {
            let format = NSLocalizedString("restoreListCellText", comment: "")//%@のバックアップ
            let valueArray: [CVarArg] = ["\(Utilities.dateFormatChangeYYYYMMDD(date: backups[row].createDate))"]
//            let cell: TableViewCell_restore = tableView.dequeueReusableCell(withIdentifier: "TableViewCell_restore") as! TableViewCell_restore
//            cell.setCell(data: Data_restore(createDate:String(format: format, arguments: valueArray)))
//            return cell
//            return backups[row]
            return String(format: format, arguments: valueArray)
        }
        return "undef"
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int{
        return backups.count;
    }
    func tableViewSelectionDidChange(_ notification: Notification){
        print("tableViewSelectionDidChange called!!")
        if(tableView.selectedRow != -1 && backups[tableView.selectedRow].text != nil){
            copyBtnTouchDown(text: backups[tableView.selectedRow].text!)
            backup_col.headerCell.stringValue="copied!!"
            tableView.reloadData()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {
                (time:Timer) in
                self.headerClear()
            })
            textView.string=backups[tableView.selectedRow].text!
            //        print("tableViewSelectionDidChange called!!")
            
//            let board = UIPasteboard.general
//            board.string = self.backups[indexPath.row].text
            
//            let _format = NSLocalizedString("restoreListCellText", comment: "")//%@のバックアップ
//            let _valueArray: [CVarArg] = ["\(Utilities.dateFormatChangeYYYYMMDD(date: self.backups[indexPath.row].createDate))"]
            
//            let format = NSLocalizedString("confirm_sentence_copy_to_clipboard", comment: "")//クリップボードに「%@」をコピーしました
//            let valueArray: [CVarArg] = [String(format: _format, arguments: _valueArray)]
//            ViewController_popup.dispText = String(format: format, arguments: valueArray)//ポップアップビューコントローラーにテキストを設定
//            self.performSegue(withIdentifier: "toPopUp", sender: nil)//ポップアップビューコントローラーを表示
        }
    }
    func headerClear()  {
        backup_col.headerCell.stringValue=""
        tableView.reloadData()
    }
    //コピーボタン押下処理
    func copyBtnTouchDown(text:String)  {
//        setStateTextBox()
        if text == "" {
            return
        }
        self.copyToClipBoard(text: (text))
    }
    func copyToClipBoard(text: String) {
        NSPasteboard.general.clearContents()
         NSPasteboard.general.setString(text, forType: .string)
//        let board = UIPasteboard.general
//        board.string = text
//        let format = NSLocalizedString("confirm_sentence_copy_to_clipboard", comment: "")//クリップボードに「%@」をコピーしました
//        let valueArray: [CVarArg] = [text]
//        ViewController_popup.dispText = String(format: format, arguments: valueArray)//ポップアップビューコントローラーにテキストを設定
//        performSegue(withIdentifier: "toPopUp", sender: nil)//ポップアップビューコントローラーを表示
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return backups.count
//    }
    
    //データ設定
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        for touch: UITouch in touches {
//            let tag = touch.view!.tag
//            if tag == 1 {
//                dismiss(animated: true, completion: nil)
//            }
//        }
//    }
    
//    @objc func willEnterForegroundNotification(_ notification: NSNotification?) {
//        if (self.isViewLoaded && (self.view.window != nil)) {
//            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            let viewContext = appDelegate.persistentContainer.viewContext
//            let query: NSFetchRequest<User> = User.fetchRequest()
//            do {
//                let fetchResults = try viewContext.fetch(query)
//                if fetchResults.count != 0 {
//                    for result: AnyObject in fetchResults {
//                        let usePassword: Bool = result.value(forKey: "usePassword") as! Bool
//                        if usePassword {
//                            self.performSegue(withIdentifier: "toPassword", sender: nil)
//                        }
//                    }
//                }
//            } catch {
//            }
//        }
//    }
    
    //スワイプ
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let swipeCell = UITableViewRowAction(style: .default, title: NSLocalizedString("copy", comment: "")) { action, index in
//
//        }
//        swipeCell.backgroundColor = .blue
//        return [swipeCell]
//    }
    
    //行クリック
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert: UIAlertController = UIAlertController(title: NSLocalizedString("confirm_title2", comment: ""),
//            message: String(format: NSLocalizedString("confirm_sentence_import2", comment: "")),
//            preferredStyle: UIAlertController.Style.alert)
//        let cancelAction: UIAlertAction = UIAlertAction(
//            title: "No",
//            style: UIAlertAction.Style.cancel,
//            handler: {
//                (action: UIAlertAction!) -> Void in
//            }
//        )
//        let defaultAction: UIAlertAction = UIAlertAction(
//            title: "Yes",
//            style: UIAlertAction.Style.default,
//            handler: {
//                (action: UIAlertAction!) -> Void in
//                let text = self.backups[indexPath.row].text
//                var cnt = 0
//                let alert_: UIAlertController = UIAlertController(title: NSLocalizedString("confirm_title", comment: ""),
//                    message: String(format: NSLocalizedString("confirm_save_current_state", comment: "")),
//                    preferredStyle: UIAlertController.Style.alert)
//                let cancelAction_: UIAlertAction = UIAlertAction(
//                    title: "No",
//                    style: UIAlertAction.Style.cancel,
//                    handler: {
//                        (action: UIAlertAction!) -> Void in
//
//                        //バックアップ処理
//                        if text != nil{
//                            cnt = Utilities.importBackUpText(text: text!)
//                        }
//                        let format = NSLocalizedString("info_sentence3", comment: "")//バックアップのリストアが完了しました(%@件)
//                        let valueArray: [CVarArg] = [String(cnt)]
//                        self.showAlert(myTitle: NSLocalizedString("info_title", comment: ""), mySentence: String(format: format, arguments: valueArray))
//                    }
//                )
//                let defaultAction_: UIAlertAction = UIAlertAction(
//                    title: "Yes",
//                    style: UIAlertAction.Style.default,
//                    handler: {
//                        (action: UIAlertAction!) -> Void in
//
//                        //現状を保存
//                        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                        let viewContext = appDelegate.persistentContainer.viewContext
//                        let entity = NSEntityDescription.entity(forEntityName: "Backup", in: viewContext)
//                        let newRecord = NSManagedObject(entity: entity!, insertInto: viewContext)
//                        newRecord.setValue(Date(), forKey: "createDate")
//                        newRecord.setValue("\(Utilities.makeBackUpText())", forKey: "text")
//                        appDelegate.saveContext()
//
//                        //バックアップ処理
//                        if text != nil{
//                            cnt = Utilities.importBackUpText(text: text!)
//
//                        }
//                        let format = NSLocalizedString("info_sentence3", comment: "")//バックアップのリストアが完了しました(%@件)
//                        let valueArray: [CVarArg] = [String(cnt)]
//                        self.showAlert(myTitle: NSLocalizedString("info_title", comment: ""), mySentence: String(format: format, arguments: valueArray))
//                    }
//                )
//                alert_.addAction(cancelAction_)
//                alert_.addAction(defaultAction_)
//                self.present(alert_, animated: true, completion: nil)
//            }
//        )
//        alert.addAction(cancelAction)
//        alert.addAction(defaultAction)
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    func showAlert(myTitle: String, mySentence: String) {
//        let alert: UIAlertController = UIAlertController(title: myTitle,
//            message: mySentence,
//            preferredStyle: UIAlertController.Style.alert)
//
//        let defaultAction: UIAlertAction = UIAlertAction(
//            title: "OK",
//            style: UIAlertAction.Style.default,
//            handler: { (action: UIAlertAction!) -> Void in }
//        )
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
//    }
}
