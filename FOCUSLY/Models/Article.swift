//
//  Article.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/02/01.
//

import SwiftUI

struct Article {
    var articleKey : ObjectIdentifier
    var articleTitle : String
    var author : String
    var createdDate : String
    var folderKey : String
    var fullLength : Int
    var startReadPosition : Int
    var lastReadPosition : Int
    var latelyPosition : Int
    var allPosition : Int
    var ownerUID : String
    var subTitle : String
}
