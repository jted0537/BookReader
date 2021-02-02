//
//  ExtensionFile.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/25.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

/* Color Variables */
/* Like Orange */
let gradationColor: Gradient = Gradient(colors: [Color(red: 1, green: 196/255, blue: 0), Color(red: 1, green: 147/255, blue: 0)])
let originalColor: Color = Color(red: 1, green: 176/255, blue: 0)
let usuallyColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
let mainColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
/* Gray Values*/
let grayLetter: Color = Color.secondary.opacity(1.5)
let grayCircle: Color = Color.secondary.opacity(0.1)
let grayIcon: Color = Color(red: 159/255, green: 159/255, blue: 159/255)
let grayBackground: Color = Color.secondary.opacity(0.1)

let backColors = [Color.secondary.opacity(0.08), Color.secondary.opacity(0.5), Color.primary.opacity(0.9), Color(hex: 0x9FE2BF), Color(hex: 0xFEF5E7), Color(hex: 0xEDBB99), Color(hex: 0x6495ED)]
let scriptFonts = [("Calibri", "칼리브리"), ("Inconsolata", "인콘솔라타"), ("PottaOne-Regular", "PottaOne")]


/* String length, substring */
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
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
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

/* Hiding KeyBoard extension */
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/* Bring Data from .docx file */
extension UTType {
    // Word documents are not an existing property on UTType
    static var word: UTType {
        // Look up the type from the file extension
        UTType.types(tag: "docx", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}


struct MultilineTextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var selectFontIdx: Int
    @Binding var selectColorIdx: Int
    @State var yOffset: CGFloat = 0 // 여기에 yoffset 계속 저장
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> MultilineUITextView {
        let view = MultilineUITextView(frame: .zero)
        view.delegate = view
        view.isScrollEnabled = true
        view.isSelectable = true
        view.isEditable = false
        view.text = self.text
        return view
    }
    
    func updateUIView(_ uiView: MultilineUITextView, context: UIViewRepresentableContext<MultilineTextView>) {
        uiView.text = self.text
        uiView.font = UIFont(name: scriptFonts[selectFontIdx].0, size: 50)
        uiView.backgroundColor = UIColor(backColors[selectColorIdx])
        
        /* Update the y offset of the textView */
        if (uiView.contentSize.height - uiView.contentOffset.y) > (UIScreen.main.bounds.height * 0.5){
            let yOffset = uiView.contentSize.height - UIScreen.main.bounds.height * 0.5
            uiView.contentOffset.y = yOffset
        }
        
    }
    
}

class MultilineUITextView: UITextView, UITextViewDelegate {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action{
        case     #selector(copy(_:)),
                 #selector(highlight),
                 #selector(repeatPlay): return true
            default: return false
        }
        
    }
    
    /* UIMenuController Functions */
    
    @objc
    func highlight() {
        print("highlight")
//        let selectedTextRange = self.selectedRange
//
//        let attribute = [NSAttributedString.Key.backgroundColor: Color.yellow]
//        let attributedText = NSAttributedString(String: selectedTextRange, attributes: attribute)
    }
    
    @objc
    func repeatPlay() {
        print("repeat the text!")
    }
    
   /*  UITextViewDelegate Methods */
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let highlightMenu = UIMenuItem(title: "하이라이트", action: #selector(MultilineUITextView.highlight))
        let repeatMenu = UIMenuItem(title: "반복재생", action: #selector(MultilineUITextView.repeatPlay))
        UIMenuController.shared.menuItems = [highlightMenu, repeatMenu]
    }
}
