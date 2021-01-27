//
//  MyLibraryView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/22.
//

import SwiftUI

/* My Library Middle Screen */
struct MyLibraryView: View {
    @State var user: User
    @State var plusPressed: Bool = false
    @State var editPressed: Bool = false
    @State private var presentActionSheet = false
    @State private var readContent: Int? = nil

    @Binding var currentView: Tab
    
    func getTimeFormat(time: Int) -> String {
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                /* 1st Item: "오늘의 읽기", Progress Bar */
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        
                        HStack(alignment: .top) {
                            Text("오늘의 읽기").font(.title).bold().foregroundColor(grayLetter)
                            
                            Image(systemName: "gearshape.fill").font(.system(size: 10)).foregroundColor(.secondary).opacity(0.8)
                            
                        }
                        HStack(spacing:0){Text("\(user.todayReadingNowMin):"+getTimeFormat(time: user.todayReadingNowSec)).foregroundColor(usuallyColor).bold()
                            Text("/\(user.todayReadingGoalMin):" + getTimeFormat(time: user.todayReadingGoalSec)).foregroundColor(grayLetter).bold()}.padding(.bottom, 15)
                        Text("매일 책을 읽어 통계 수치를 높이고 더 많은 도서를 완독하세요!").foregroundColor(grayLetter).font(.caption)
                    }
                    Spacer()
                    
                    ZStack(alignment: .trailing){
                        Circle()
                            .opacity(0.3)
                            .foregroundColor(grayCircle)
                            .frame(width: 120, height:120)
                        
                        Path { path in
                            path.addArc(center: .init(x: 60, y: 60), radius: 60, startAngle: .degrees(0), endAngle: .degrees(360*user.todayReadingRatio), clockwise: true)
                        }
                        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(usuallyColor)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(90))
                        
                        Text("\(Int(user.todayReadingRatio*100.0))%").bold().font(.title).foregroundColor(grayLetter)
                            .frame(width: 120, height: 120)
                    } /* Progress bar */
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                
                /* Book Scroll */
                ZStack{
                    Color.secondary.opacity(0.1)
                    ScrollView{
                        ForEach(user.playlist){ script in
                            ReadingRow(editPressed: $editPressed, readContent: $readContent, script: $user.playlist[script.id-1])
                        }
                    }
                }
                
                /* Repeat Button */
                HStack(spacing: 3){
                    Button(action: {}){
                        HStack{
                            Spacer()
                            Image(systemName: "repeat")
                            Text("전체반복")
                            Spacer()
                        }.frame(height: 50).background(usuallyColor)
                        
                    }
                    Button(action: {}){
                        HStack{
                            Spacer()
                            Image(systemName: "shuffle")
                            Text("랜덤읽기")
                            Spacer()
                        }.frame(height: 50).background(usuallyColor)
                        
                    }
                }.foregroundColor(.white)
                
        }
       
            if readContent != nil{
                BookView(curContent: $user.playlist[readContent!-1])
            }
            
        }
    }
}
