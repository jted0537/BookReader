//
//  ExtensionFile.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/25.
//

import SwiftUI

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
}

/* Color Variables */
let gradationColor: Gradient = Gradient(colors: [Color(red: 1, green: 196/255, blue: 0), Color(red: 1, green: 147/255, blue: 0)])
let originalColor: Color = Color(red: 1, green: 176/255, blue: 0)
let usuallyColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
let grayLetter: Color = Color(red: 96/255, green: 96/255, blue: 96/255)
let grayCircle: Color = Color(red: 238/255, green: 238/255, blue: 238/255)
let grayBox: Color = Color(red: 229/255, green: 229/255, blue: 229/255)
let grayIcon: Color = Color(red: 159/255, green: 159/255, blue: 159/255)
let grayBackground: Color = Color(red: 247/255, green: 247/255, blue: 247/255)
let mainColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
let offWhite: Color = Color(hex: 0xF7F7F7)

let backColors = [Color(hex: 0xF7F7F7), Color(hex: 0xCACFD2), Color(hex: 0x000000), Color(hex: 0x9FE2BF), Color(hex: 0xFEF5E7), Color(hex: 0xEDBB99), Color(hex: 0x6495ED)]
let scriptFonts = [("Calibri", "칼리브리"), ("Inconsolata", "인콘솔라타"), ("PottaOne-Regular", "PottaOne")]

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

/* Make Aritificial TextField MultiLine */
struct MakeContentsMultilineText: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> MakeContentsMultilineText.Coordinator {
        return MakeContentsMultilineText.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MakeContentsMultilineText>) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.text = "내용을 입력하세요"
        view.textColor = UIColor(grayIcon.opacity(0.6))
        view.font = .systemFont(ofSize: 17)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent : MakeContentsMultilineText
        init(parent1: MakeContentsMultilineText){
            parent = parent1
        }
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .label
        }
    }
}

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var selectFontIdx: Int
    @Binding var selectColorIdx: Int
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> UITextView {
        let view = newTextView()
        view.isScrollEnabled = true
        view.isSelectable = true
        view.isEditable = false
        view.text = self.text
        //view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        uiView.font = UIFont(name: scriptFonts[selectFontIdx].0, size: 60)
        uiView.backgroundColor = UIColor(backColors[selectColorIdx])
    }
    
}

//extension UITextView {
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return (action == #selector(userSelect))
//    }
//
//}

func textViewDidBeginEditing(_ textView: UITextView) {
    let menu = UIMenuItem(title: "zedd", action: #selector(newTextView.userSelect))
    UIMenuController.shared.menuItems = [menu]
}

class newTextView: UITextView {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(userSelect))
    }
    
    @objc
    
    func userSelect() {
        print("wdmqlmqwklmdqwkmdwqlmqwklmwdqlmqwlmkdqwk")
    }
}
