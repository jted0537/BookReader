//
//  MyLibraryView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/22.
//
import SwiftUI

/* My Library Middle Screen */
struct MyLibraryView: View {
    /* State Variables */
    @State var user: User
    @State private var editPressed: Bool = false
    @State private var readContent: Int? = nil
    
    /* Binding Variables */
    @Binding var currentView: Tab
    
    /* Time Formatter */
    func getTimeFormat(time: Int) -> String {
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    /* My Library Main */
    var body: some View {
        VStack(spacing: 0) {
            /* 1st Item: "오늘의 읽기", Progress Bar */
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    
                    HStack(alignment: .top) {
                        Text("오늘의 읽기").font(.title).bold().foregroundColor(grayLetter).bold()
                        
                        Image(systemName: "gearshape.fill").font(.system(size: 10)).foregroundColor(.secondary).opacity(0.8)
                        
                    }
                    HStack(spacing:0){Text("\(user.todayReadingNowMin):"+getTimeFormat(time: user.todayReadingNowSec)).foregroundColor(usuallyColor)
                        Text("/\(user.todayReadingGoalMin):" + getTimeFormat(time: user.todayReadingGoalSec)).foregroundColor(grayLetter)}.padding(.bottom, 15)
                    Text("매일 책을 읽어 통계 수치를 높이고 더 많은 도서를 완독하세요!").foregroundColor(grayLetter).font(.caption)
                }
                Spacer()
                
                ZStack(alignment: .trailing){
                    Circle()
                        .foregroundColor(grayCircle)
                        .frame(width: 120, height: 120)
                    
                    Path { path in
                        path.addArc(center: .init(x: 60, y: 60), radius: 60, startAngle: .degrees(0), endAngle: .degrees(360*user.todayReadingRatio), clockwise: true)
                    }
                    .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(usuallyColor)
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(90))
                    
                    Text("\(Int(user.todayReadingRatio*100.0))%").foregroundColor(grayLetter).font(.title).bold()
                        .frame(width: 120, height: 120)
                } /* Progress Circle */
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            
            /* Contents Scroll */
            ZStack{
                grayBackground.ignoresSafeArea()
                
                ScrollView{
                    Rectangle().opacity(0).frame(height: 5)
                    ForEach(user.playlist){ contents in
                        ReadingRow(editPressed: $editPressed, readContent: $readContent, contents: $user.playlist[contents.id-1])
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
                    }.frame(height: 60).background(usuallyColor)
                    
                }
                Button(action: {}){
                    HStack{
                        Spacer()
                        Image(systemName: "shuffle")
                        Text("랜덤읽기")
                        Spacer()
                    }.frame(height: 60).background(usuallyColor)
                    
                }
            }.foregroundColor(Color.white)
            
    }
       
    }
}
