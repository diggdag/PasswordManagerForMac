//
//  ViewController_generate.swift
//  PasswordManager
//
//  Created by 倉知諒 on 2021/03/06.
//  Copyright © 2021 R.Kurachi. All rights reserved.
//

import Cocoa
import CoreData
class ViewController_generate:NSViewController,NSTableViewDelegate,NSTableViewDataSource{
    var passwords : [String] = []
    let ALLNUM:[String] = ["0","1","2","3","4","5","6","7","8","9"]
    let ALLALPHABETAPPER:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    let ALLALPHABETLOWER:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let ALLMARK:[String] = ["!","?",":",";","+","*","/","-","~","¥","=","#","$","%","&","(",")","<",">","_","[","]","{","}","@"]
    let PASSWORDCOUNT = 16
    let SEGMENTVALUE = [4,8,16,32]
    let CLUMNWIDTH = [70.0,140.0,140.0,280.0]
    
    @IBOutlet var swNum: NSButton!
    @IBOutlet var swAlphaUpper: NSButton!
    @IBOutlet var swAlphaLower: NSButton!
    @IBOutlet var swMark: NSButton!
    @IBOutlet weak var tableView: NSTableView!
//    @IBOutlet weak var swNum: NSSwitch!
//    @IBOutlet weak var swAlphaUpper: NSSwitch!
//    @IBOutlet weak var swAlphaLower: NSSwitch!
//    @IBOutlet weak var swMark: NSSwitch!
    @IBOutlet weak var charLength: NSSegmentedControl!
    @IBOutlet var passwordCol: NSTableColumn!
    //    @IBOutlet weak var back: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.dataSource = self
//        collectionView.delegate = self
        //文字数セグメント作成
//        charLength.removeAllSegments()
        charLength.segmentCount = SEGMENTVALUE.count
        for i in 0...SEGMENTVALUE.count - 1  {
//            charLength.insertSegment(withTitle:String(SEGMENTVALUE[i]), at: i, animated: false)
            charLength.setLabel(String(SEGMENTVALUE[i]), forSegment: i)
        }
//        charLength.selectedSegmentIndex = 1
        charLength.selectedSegment = 1
        
        passwords = []
        //背景設定
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        back.layer.cornerRadius = 50 * 0.5
//        back.clipsToBounds = true
    }
    
    @IBAction func touchDown_generate(_ sender: Any) {
        
        //validation start
        var allFalse = true
        if swNum.state == .on {
            allFalse = false
        }
        if swAlphaUpper.state == .on {
            allFalse = false
        }
        if swAlphaLower.state == .on {
            allFalse = false
        }
        if swMark.state == .on {
            allFalse = false
        }
        if allFalse {
            print("チェック全てなし")
            return
        }
        //validation end
        
        if regenerate() {
            tableView.reloadData()
        }
    }
    //テーブルに値設定
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?{
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("col_password") {
            return passwords[row]

        }
        return "undef"
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int{
        return passwords.count;
    }
    func tableViewSelectionDidChange(_ notification: Notification){
        print("tableViewSelectionDidChange called!!")
        copyBtnTouchDown(text: passwords[tableView.selectedRow])
        passwordCol.headerCell.stringValue="copied!!"
        tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {(time:Timer) in self.headerClear()})
        //        print("tableViewSelectionDidChange called!!")
    }
    func headerClear()  {
        passwordCol.headerCell.stringValue=""
        tableView.reloadData()
    }
//    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
//        return passwords.count;
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return passwords.count;
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell_generate", for: indexPath) as! CollctionViewCell_generate
//
//        cell.setCell(data: Data_generate(password: passwords[Int(indexPath.row)]))
//            return cell
//    }
//    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
//        <#code#>
//    }
    
    func regenerate() -> Bool {
        var allchar:[[String]] = []
        passwords = []
        if swNum.state == .on {
            allchar.append(ALLNUM)
        }
        if swAlphaUpper.state == .on {
            allchar.append(ALLALPHABETAPPER)
        }
        if swAlphaLower.state == .on {
            allchar.append(ALLALPHABETLOWER)
        }
        if swMark.state == .on {
            allchar.append(ALLMARK)
        }
        
        if allchar.count == 0 {
            return false
        }
        
        for _ in 1...PASSWORDCOUNT {
            var password = ""
            for _ in 1...SEGMENTVALUE[charLength.selectedSegment] {
                password+=(allchar.randomElement()?.randomElement())!
            }
            passwords.append(password)
        }
        passwordCol.width = CLUMNWIDTH[charLength.selectedSegment]
        return true
    }
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        copyToClipBoard(text: self.passwords[Int(indexPath.row)])
//   }
    
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
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        for touch: UITouch in touches {
//            let tag = touch.view!.tag
//            if tag == 1 {
//                dismiss(animated: true, completion: nil)
//            }
//        }
//    }
}
