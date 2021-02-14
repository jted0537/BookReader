//
//  ExtensionFile.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/25.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
import Foundation

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

let backColors = [Color.secondary.opacity(0.07), Color.secondary.opacity(0.5), Color.primary.opacity(0.9), Color(hex: 0x9FE2BF), Color(hex: 0xFEF5E7), Color(hex: 0xEDBB99), Color(hex: 0x6495ED)]
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

/* Hiding KeyBoard extension */
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/* Bring Data from .docx file */
extension UTType {
    // Word documents are not an existing property on UTType
    static var docx: UTType {
        // Look up the type from the file extension
        UTType.types(tag: "docx", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}


struct MultilineTextView: UIViewRepresentable {
    //@State var highlightedWords: NSAttributedString// 쓸지 미지수
    @Binding var text: String
    @Binding var selectFontIdx: Int
    @Binding var selectColorIdx: Int
    //하이라이트
    @Binding var isHighlightSelect: Bool
    @Binding var highlightedContent: [UITextRange]
    //구간반복
    @Binding var isRepeatMode: Bool
    @Binding var repeatContent: String
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> MultilineUITextView {
        let view = MultilineUITextView(isHighlightSelect: self.$isHighlightSelect, highlightedContent: self.$highlightedContent, isRepeatMode: self.$isRepeatMode, repeatContent: self.$repeatContent)
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
    // 하이라이트
    @Binding var isHighlightSelect: Bool
    @Binding var highlightedContent: [UITextRange]
    // 구간반복
    @Binding var isRepeatMode: Bool
    @Binding var repeatContent: String
    
    init(isHighlightSelect highlightselect: Binding<Bool>, highlightedContent highlightContent: Binding<[UITextRange]>, isRepeatMode repeatMode: Binding<Bool>, repeatContent repeatedContent: Binding<String>) {
        self._isHighlightSelect = highlightselect
        self._highlightedContent = highlightContent
        self._isRepeatMode = repeatMode
        self._repeatContent = repeatedContent
        super.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //super.init(coder: aDecoder) -> error
    }

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
        let mstr = NSMutableAttributedString(attributedString: self.attributedText)
        mstr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(Color.yellow), range: self.selectedRange)

        self.attributedText = NSAttributedString(attributedString: mstr)
        
//        let attribute = [NSAttributedString.Key.backgroundColor: UIColor(Color.yellow)]
//        self.textStorage.addAttributes(attribute as [NSAttributedString.Key : Any], range: self.selectedRange)
        
        
        // added code
        //self.isHighlightSelect = true
        //self.highlightedContent.append(self.selectedTextRange!)
        
        print(self.selectedRange)
        print(self.textStorage)
    }
    
    @objc
    func repeatPlay() {
        print("repeat the text!")
        self.isRepeatMode = true
        // 나중에 가드로 묶어야 함
        self.repeatContent = self.text(in: self.selectedTextRange!)!
    }
    
   /*  UITextViewDelegate Methods */
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let highlightMenu = UIMenuItem(title: "하이라이트", action: #selector(highlight))
        let repeatMenu = UIMenuItem(title: "반복재생", action: #selector(repeatPlay))
        UIMenuController.shared.menuItems = [highlightMenu, repeatMenu]
    }
    
}
