//
//  MultiLineText.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/02/19.
//

import SwiftUI
import UIKit
import Foundation

/* for ArticleView */
/* customized MultilineTextView */
/* Purpose: to make view to be multiline & scrollable & selectable */
struct MultilineTextView: UIViewRepresentable {
    // TextView Customize Properties
    @Binding var text: String
    @Binding var selectFontIdx: Int
    @Binding var selectColorIdx: Int
    // Repeat Function Variables
    @Binding var isRepeatMode: Bool
    @Binding var repeatContent: String
    // Highlight Function Variables
    @Binding var highlightContent: [NSRange]
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextView>) -> MultilineUITextView {
        let view = MultilineUITextView(isRepeatMode: self.$isRepeatMode, repeatContent: self.$repeatContent, highlightContent: self.$highlightContent)
        view.delegate = view
        view.isScrollEnabled = true
        view.isSelectable = true
        view.isEditable = false
        view.text = self.text
        return view
    }
    
    func updateUIView(_ uiView: MultilineUITextView, context: UIViewRepresentableContext<MultilineTextView>) {
        // In case view's properties modified
        uiView.text = self.text
        uiView.font = UIFont(name: scriptFonts[selectFontIdx].0, size: 50)
        uiView.backgroundColor = UIColor(backColors[selectColorIdx])

        /* Update the y offset of the textView */
        /* to make current text view's display in the right place */
        if (uiView.contentSize.height - uiView.contentOffset.y) > (UIScreen.main.bounds.height * 0.5){
            let yOffset = uiView.contentSize.height - UIScreen.main.bounds.height * 0.5
            uiView.contentOffset.y = yOffset
        }
        
        // for saving the highlights history
        let mstr = NSMutableAttributedString(attributedString: uiView.attributedText)

        for highlight in self.highlightContent {
            mstr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(Color.yellow), range: highlight)
       }
        
        uiView.attributedText = NSAttributedString(attributedString: mstr)
    }
    
}

/* to customize MultilineTextView */
/* Add highlight & repea† Functions to UIMenuController */
/* isRepeatMode, repeatContent : ArticleView's State Variables */
class MultilineUITextView: UITextView, UITextViewDelegate {
    // RepeatMode Properties
    @Binding var isRepeatMode: Bool
    @Binding var repeatContent: String
    // Highlight Function Variables
    @Binding var highlightContent: [NSRange]
    
    init(isRepeatMode repeatMode: Binding<Bool>, repeatContent repeatedContent: Binding<String>, highlightContent highlightedContent: Binding<[NSRange]>) {
        self._isRepeatMode = repeatMode
        self._repeatContent = repeatedContent
        self._highlightContent = highlightedContent
        super.init(frame: .zero, textContainer: nil)
    }
    
    // Required Initializer for Binding Variables
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // For Customizing uiMenuController
    // After Selecting, Add copy, highlight, repeatPlay selector to menu
    // Else, Return false
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action{
        case     #selector(copy(_:)),
                 #selector(highlight),
                 #selector(repeatPlay): return true
            default: return false
        }
        
    }
    
    /* UIMenuController Functions */
    // Add Yellow Background Highlight to Selected Text
    @objc
    func highlight() {
        // append currently selected range
        self.highlightContent.append(selectedRange)
        
        let mstr = NSMutableAttributedString(attributedString: self.attributedText)
        mstr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor(Color.yellow), range: self.selectedRange)

        self.attributedText = NSAttributedString(attributedString: mstr)
    }
    
    // Turn on the RepeatMode flag & Repeat the Selected Text
    @objc
    func repeatPlay() {
        self.isRepeatMode = true
        self.repeatContent = self.text(in: self.selectedTextRange!)!
    }
    
    /*  UITextViewDelegate Methods */
    // If Selected Section Changes
    func textViewDidChangeSelection(_ textView: UITextView) {
        let highlightMenu = UIMenuItem(title: "하이라이트", action: #selector(highlight))
        let repeatMenu = UIMenuItem(title: "반복재생", action: #selector(repeatPlay))
        UIMenuController.shared.menuItems = [highlightMenu, repeatMenu]
    }
    
}
