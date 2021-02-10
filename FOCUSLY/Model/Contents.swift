//
//  ReadingInformation.swift
//  focusly
//
//  Created by 윤다영 on 2021/01/12.
//

import Foundation
import SwiftUI

/*class Contents: NSObject, Identifiable {
 public var id: Int
 public var title: String
 public var publisher: String
 public var date: Date
 public var fullContent: String
 public var readTime: Int = 80
 public var readIdx: Int = 0
 
 var readProgress: Double {
 get{
 return Double(readIdx+1) / Double(fullContent.length)
 }
 }
 
 //public var readeds
 let formater = DateFormatter()
 
 init(recordId: Int, title: String, pub: String){
 let year = Calendar.current.component(.year, from: Date())
 let month = Calendar.current.component(.month, from: Date())
 let day = Calendar.current.component(.day, from: Date())
 
 self.id = recordId
 self.title = title
 self.publisher = pub
 self.date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
 self.fullContent = "\(self.id)th post: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
 self.formater.dateFormat = "y/m/d"
 }
 
 // dummy data 30개 생성
 static func generateReadings() -> [Contents] {
 var readings = [Contents]()
 
 for idx in 1...30{
 let newReading = Contents(recordId: idx, title: "\(idx)th 게시물", pub: "\(idx)th auth")
 readings.append(newReading)
 }
 
 return readings
 }
 }*/

struct Contents: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let fullContent: String
    //let readTime: Int
    var readIdx: Int
    
    var readProgress: Double {
        get{
            return Double(readIdx+1) / Double(fullContent.length)
        }
    }
    
}
