//
//  Extentions.swift
//  PasswordManager
//
//  Created by R.Kurachi on 2018/08/11.
//  Copyright © 2018年 R.Kurachi. All rights reserved.
//

import Cocoa

//import UIKit
//
//extension UIButton {
//    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
//        let image = color.image
//        setBackgroundImage(image, for: state)
//    }
//}
//
//extension UIColor {
//    var image: UIImage? {
//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
//        UIGraphicsBeginImageContext(rect.size)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//        context.setFillColor(self.cgColor)
//        context.fill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//
//    /// ライト/ダーク用の色を受け取ってDynamic Colorを作って返す
//    public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
//        if #available(iOS 13, *) {
//            return UIColor { (traitCollection) -> UIColor in
//                if traitCollection.userInterfaceStyle == .dark {
//                    return dark
//                } else {
//                    return light
//                }
//            }
//        }
//        return light
//    }
//
//    convenience init(rgb: Int) {
//        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//        let g = CGFloat((rgb & 0x00FF00) >>  8) / 255.0
//        let b = CGFloat( rgb & 0x0000FF       ) / 255.0
//        self.init(red: r, green: g, blue: b, alpha: 1.0)
//    }
//}
//
//extension String {
//
//    /// 正規表現でキャプチャした文字列を抽出する
//    ///
//    /// - Parameters:
//    ///   - pattern: 正規表現
//    ///   - group: 抽出するグループ番号(>=1)
//    /// - Returns: 抽出した文字列
//    func capture(pattern: String, group: Int) -> String? {
//        let result = capture(pattern: pattern, group: [group])
//        return result.isEmpty ? nil : result[0]
//    }
//
//    /// 正規表現でキャプチャした文字列を抽出する
//    ///
//    /// - Parameters:
//    ///   - pattern: 正規表現
//    ///   - group: 抽出するグループ番号(>=1)の配列
//    /// - Returns: 抽出した文字列の配列
//    func capture(pattern: String, group: [Int]) -> [String] {
//        guard let regex = try? NSRegularExpression(pattern: pattern) else {
//            return []
//        }
//
//        guard let matched = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)) else {
//            return []
//        }
//
//        return group.map { group -> String in
//            return (self as NSString).substring(with: matched.range(at: group))
//        }
//    }
//}
//extension UITraitCollection {
//
//    public static var isDarkMode: Bool {
//        if #available(iOS 13, *), current.userInterfaceStyle == .dark {
//            return true
//        }
//        return false
//    }
//
//}
extension NSApplication {
    public var isDarkMode: Bool {
        if #available(OSX 10.14, *) {
            let name = effectiveAppearance.name
            return name == .darkAqua
        }
        else {
            return false
        }
    }
}
extension String {
    func numberOfOccurrences(of word: String) -> Int {
        var count = 0
        var nextRange = self.startIndex..<self.endIndex
        while let range = self.range(of: word, options: .caseInsensitive, range: nextRange) {
            count += 1
            nextRange = range.upperBound..<self.endIndex
        }
        return count
    }
}
extension NSImage {
    var toCGImage: CGImage {
        var imageRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        #if swift(>=3.0)
        guard let image =  cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            abort()
        }
        #else
        guard let image = CGImageForProposedRect(&imageRect, context: nil, hints: nil) else {
            abort()
        }
        #endif
        return image
    }
}
extension CGImage {
    var size: CGSize {
        #if swift(>=3.0)
        #else
        let width = CGImageGetWidth(self)
        let height = CGImageGetHeight(self)
        #endif
        return CGSize(width: width, height: height)
    }

    var toNSImage: NSImage {
        #if swift(>=3.0)
        return NSImage(cgImage: self, size: size)
        #else
        return NSImage(CGImage: self, size: size)
        #endif
    }
}
