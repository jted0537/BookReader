//
//  User.swift
//  fcusly
//
//  Created by 윤다영 on 2021/01/13.
//

import Foundation

class User: NSObject, Identifiable {
    public var id: Int
    public var username: String
    public var playlist: [Book]
    public var todayReadingGoal: Int = 0 // 초 단위로 저장
    public var todayReadingNow: Int = 0 // 초 단위로 저장
    public var todayReadingGoalMin: Int {
        get {
            return todayReadingGoal/60
        }
    }
    public var todayReadingGoalSec: Int {
        get {
            return todayReadingGoal%60
        }
    }
    public var todayReadingNowMin: Int {
        get {
            return todayReadingNow/60
        }
    }
    public var todayReadingNowSec: Int {
        get {
            return todayReadingNow%60
        }
    }
    public var todayReadingRatio: Double {
        // 오늘의 읽기 진척도
        get {
            return Double(todayReadingNow)/Double(todayReadingGoal)
        }
    }
    
    init(idx: Int, name: String){
        self.id = idx
        self.username = name
        self.playlist = [Book]()
    }
    
    static func generateUser() -> User {
        var user = User(idx: 1, name: "dayoung")
        user.playlist = Book.generateReadings()
        user.todayReadingGoal = 300
        user.todayReadingNow = 160
        return user
    }
}

