//
//  MyLibraryView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/22.
//

import SwiftUI

/* 나의서재 View */
struct MyLibraryView: View {
    @State var user: User
    @State var plusPressed: Bool = false
    func getTimeFormat(time: Int) -> String {
        return time < 10 ? "0\(time)" : "\(time)"
    }
    
    var body: some View {
        
        GeometryReader{geometry in
            VStack(spacing: 0) {
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        
                        HStack(alignment: .top) {
                            Text("오늘의 읽기").font(.title).bold().foregroundColor(grayLetter)
                            
                            Image(systemName: "gearshape.fill").font(.system(size: 10)).foregroundColor(.secondary).opacity(0.8)
                            
                        }
                        HStack(spacing:0){Text("\(user.todayReadingNowMin):"+getTimeFormat(time: user.todayReadingNowSec)).foregroundColor(usuallyColor).bold()
                            Text("/\(user.todayReadingGoalMin):" + getTimeFormat(time: user.todayReadingGoalSec)).foregroundColor(grayLetter).bold()}.padding(.bottom, 15)
                        Text("매일 책을 읽어 통계 수치를 높이고 더 많은 도서를 완독하세요!").foregroundColor(grayLetter).font(.caption)//.frame(width: geometry.size.width/2)
                    }
                    Spacer()
                    
                    
                    ZStack(alignment: .trailing){
                        Circle()
                            .opacity(0.3)
                            .foregroundColor(grayCircle)
                            .frame(width: 120, height:120)
                        GeometryReader { geometry in
                            Path { path in
                                let size = min(geometry.size.width, geometry.size.height)
                                path.addArc(center: .init(x: size/2, y: size/2), radius: size/2, startAngle: .degrees(0), endAngle: .degrees(360*user.todayReadingRatio), clockwise: true)
                            }
                            .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(usuallyColor)
                        }
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(90))
                        Text("\(Int(user.todayReadingRatio*100.0))%").bold().font(.title).foregroundColor(grayLetter)
                            .frame(width: 120, height: 120)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                //오늘의 읽기, Progress bar
                
                ZStack{
                    Color.secondary.opacity(0.1)
                    ScrollView{
                        ForEach(user.playlist){ reading in
                            ReadingRow(reading: reading)
                        }
                        
                    }
                }
                //Book list
                
                HStack(spacing: 3){
                    Button(action: {}){
                        HStack{
                            Image(systemName: "questionmark.square")
                            Text("전체반복")
                        }.frame(width: geometry.size.width/2, height: 50).background(usuallyColor)
                        
                    }
                    Button(action: {}){
                        HStack{
                            Image(systemName: "questionmark.square")
                            Text("랜덤읽기")
                        }.frame(width: geometry.size.width/2, height: 50).background(usuallyColor)
                        
                    }
                }.padding(.leading, 0).foregroundColor(.white) //전체반복, 랜덤읽기
                
            }.navigationBarHidden(true)
        }
        
        
    }
}


struct PlusPressedView: View {
    var body: some View{
        GeometryReader{ geometry in
            HStack(spacing: 0){
                Spacer()
                Button(action: {
                    
                }){
                    Image(systemName: "pencil")
                }.frame(width: geometry.size.width/6)
                
                Button(action: {
                    
                }){
                    Image(systemName: "camera")
                }.frame(width: geometry.size.width/6)
                
                Button(action: {
                    
                }){
                    Image(systemName: "paperclip")
                }.frame(width: geometry.size.width/6)
            }
        }
    }
}

