//
//  ReadingInformation.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.
//

import Foundation
import SwiftUI


struct Article: Decodable, Identifiable {
    var id: String
    //let articleKey: String
    let articleTitle: String
    //let author: String
    let createdDate: Date
    let fullLength: Int
    
    var lastReadPosition: Int
    //let ownerUid: String
}
