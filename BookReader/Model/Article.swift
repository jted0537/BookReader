//
//  Article.swift
//  purpose: base model for article model
//
//  Created by 윤다영 on 2021/01/12.
//

import Foundation
import SwiftUI

/* not used */
// Higlight Model
// highlightKey: key of higlighted object
// color: highlight color
// highlightRange: highlighted range (transferred to range variable later)
struct Highlight {
    let highlightKey: String
    var color: Int
    let startPosition: Int
    let length: Int
}

// Article Model
// id: article key (variable name to observe Identifiable protocol)
// articleTitle: article's title
// article: article's contents
// createdDate: article's created date
struct Article: Identifiable {
    let id: String
    let articleTitle: String
    let article: String
    //let author: String
    let createdDate: String
    
    var lastReadPosition: Int
    //let ownerUid: String
    
    //var highlights: [Highlight] = []
}

