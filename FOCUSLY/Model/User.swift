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
// playlist: article 저장
// todayReadingGoal: 오늘의 읽기 목표 시간
// todayReadingNow: 오늘의 읽기 현재 읽은 시간
struct User: Identifiable {
    let id = UUID()
    //let username: String
    let playlist: [Article]
    let todayReadingGoal: Int = 0 // 초 단위로 저장
    let todayReadingNow: Int = 0 // 초 단위로 저장
}
