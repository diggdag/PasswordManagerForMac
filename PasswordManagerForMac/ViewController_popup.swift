//
//  ViewController_popup.swift
//  PasswordManager
//
//  Created by 倉知諒 on 2017/07/03.
//  Copyright © 2017年 R.Kurachi. All rights reserved.
//

import Cocoa

class ViewController_popup: NSViewController {
    @IBOutlet var popUpImage: NSImageView!
    @IBOutlet var text: NSTextField!
    //    @IBOutlet var popUpImage: NSButton!
    let DISPLAYTIME: TimeInterval = 2
//    @IBOutlet var text: NSButtonCell!
    //    @IBOutlet weak var text: UILabel!
//    @IBOutlet weak var popUpImage: UIImageView!
//    @IBOutlet weak var popUpView: UIView!
    static var dispText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        text.adjustsFontSizeToFitWidth = true
        text.stringValue = ViewController_popup.dispText
        //ダイナミックカラーの設定（ダークモード対応）
        if(NSApplication.shared.isDarkMode){
            
//            text.textColor=NSColor.init(name: NSColor.white, dynamicProvider: <#T##(NSAppearance) -> NSColor#>{
//
//            })
            text.textColor=NSColor.black
            //トーストのイメージの設定（ダークモード対応）
//            popUpImage.image=NSTraitCollection.isDarkMode ? NSImage(named: Consts.TOAST_WHITE_IMAGE)! : NSImage(named: Consts.TOAST_BLACK_IMAGE)!
            //トーストのイメージの設定（ダークモード対応）
            popUpImage.image=NSImage(named: Consts.TOAST_WHITE_IMAGE)!
        }
        else{
            text.textColor=NSColor.white
            //トーストのイメージの設定（ダークモード対応）
            popUpImage.image=NSImage(named: Consts.TOAST_BLACK_IMAGE)!
        }
//        text.textColor=NSColor.dynamicColor(light: NSColor.white, dark: NSColor.black)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DISPLAYTIME) {
//            self.dismiss(animated: true, completion: nil)
            self.dismiss(nil)
        }
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
