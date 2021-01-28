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
let scriptFonts = [(Font.custom("HANBatang-LVT", size: 33), "한초롱바탕"), (Font.custom("HANDotum-LVT", size: 33), "한초롱돋움"), (Font.custom("PottaOne-Regular", size: 33), "포타원")]

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
