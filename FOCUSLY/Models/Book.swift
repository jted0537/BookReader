//
//  ReadingInformation.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.
//

import SwiftUI

class Book: NSObject, Identifiable {
    public var id: Int
    public var title: String
    public var publisher: String
    public var date: Date
    public var readProgress: Double = 0.0
    public var content: String = "글 내용"
    let formater = DateFormatter()
    
    init(recordId: Int, title: String, pub: String){
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        
        self.id = recordId
        self.title = title
        self.publisher = pub
        self.date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
        self.content.append("\(self.id)")
        self.formater.dateFormat = "y/m/d"
    }
    
    // dummy data 30개 생성
    static func generateReadings() -> [Book] {
        var readings = [Book]()
        
        for idx in 1...30{
            let newReading = Book(recordId: idx, title: "\(idx)th 게시물", pub: "\(idx)th auth")
            readings.append(newReading)
        }
        
        return readings
    }
}
