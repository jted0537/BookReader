//
//  Article.swift
//  purpose: base model for article model
//
//  Created by 윤다영 on 2021/01/12.
//

import Foundation
import SwiftUI

// Higlight Model
// highlightKey: 하이라이트된 객체의 key
// color: 하이라이트 색상
// highlightRange: 하이라이트된 범위 (후에 range 형 변수로 변환)
struct Highlight {
    var highlightKey: String
    var color: String
    var highlightRange: String
}

// Article Model
// id: article key (Identifiable protocol 준수하기 위한 변수 이름)
// articleTitle: article 제목
// article: article 내용
// createdDate: article 생성날짜
struct Article: Identifiable {
    let id: String
    let articleTitle: String
    let article: String
    //let author: String
    let createdDate: String
    
    var lastReadPosition: Int
    //let ownerUid: String
    
    //var highlightInfo: Highlight
}
