//
//  User.swift
//  purpose: base model for user model
//
//  Created by 윤다영 on 2021/01/13.
//

import Foundation
import SwiftUI

// UserModel
// id: user key
// playlist: to save article
// todayReadingGoal: Today's reading goal time
// todayReadingNow: Today's reading current time
struct User: Identifiable {
    let id = UUID()
    var articles: [Article] = []
    var todayReadingGoal: Int = 0 // save the time in seconds
    var todayReadingNow: Int = 0 // save the time in seconds
}

