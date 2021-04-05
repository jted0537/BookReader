//
//  ExtensionFile.swift
//
//  purpose: to save structs, classes, color variables, extensions used in views
//  contents: Color variables, String&Color&UINavigationController&View&UTType extensions,
//            Customized MultilineTextView, MultilineUITextView
//
//  Created by 정동혁 on 2021/01/25.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
//import Foundation

/* Color Variables */
/* Orange Values */
let gradationColor: Gradient = Gradient(colors: [Color(red: 1, green: 196/255, blue: 0), Color(red: 1, green: 147/255, blue: 0)])
let originalColor: Color = Color(red: 1, green: 176/255, blue: 0)
let usuallyColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
let mainColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
/* Gray Values*/
let grayLetter: Color = Color.secondary.opacity(1.5)
let grayCircle: Color = Color.secondary.opacity(0.1)
let grayIcon: Color = Color(red: 159/255, green: 159/255, blue: 159/255)
let grayBackground: Color = Color.secondary.opacity(0.1)
/* Article View custom (배경색, 폰트) */
let backColors = [Color.secondary.opacity(0.07), Color.secondary.opacity(0.5), Color.primary.opacity(0.9), Color(hex: 0x9FE2BF), Color(hex: 0xFEF5E7), Color(hex: 0xEDBB99), Color(hex: 0x6495ED)]
let scriptFonts = [("Calibri", "칼리브리"), ("Inconsolata", "인콘솔라타"), ("PottaOne-Regular", "PottaOne")]
let highlightColors = [Color.yellow, Color.pink, Color.orange]

/* String length, substring extensions */
extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)), upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

/* Using Color Hex Code */
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    #if os(macOS)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    #else
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    #endif
}

/* NavigationBar Swipe With Custom BackButton */
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

/* Hiding KeyBoard extension for MakeContentsView.swift */
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/* Bring Data from .docx file */
/* for docx parsing & upload */
extension UTType {
    // Word documents are not an existing property on UTType
    static var docx: UTType {
        // Look up the type from the file extension
        UTType.types(tag: "docx", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}
