//
//  TempView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/25.
//
import SwiftUI

let backColors = [Color(hex: 0xF8F9F9), Color(hex: 0xCACFD2), Color(hex: 0x000000), Color(hex: 0x9FE2BF), Color(hex: 0xFEF5E7), Color(hex: 0xEDBB99), Color(hex: 0x6495ED)]
let scriptFonts = [(Font.custom("HANBatang-LVT", size: 33), "한초롱바탕"), (Font.custom("HANDotum-LVT", size: 33), "한초롱돋움"), (Font.custom("PottaOne-Regular", size: 33), "포타원")]

struct BookView: View {
    
    @State var rollUp: Bool = false
    @State var selectColorIdx = 0
    @State var selectFontIdx = 0
    @State var count = 0
    @State var isActive = false
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 0.6, on: .main, in: .common)
    @State var interval: Double = 0.5
    @State var place: Double = 0.0
    
    //@Binding var readContentKey: Int
    @Binding var curContent: Script
    @State var readedContent: String=""
    
    var body: some View {
        ZStack{
            Color.secondary.opacity(0.1)
            
            VStack(spacing: 0){
                /* 상단바 */
                HStack(spacing: 20){
    //                Button(action: {
    //                    withAnimation{
    //                        self.readContentKey =
    //                    }
    //                }){
    //                    Image(systemName: "arrow.backward")
    //                }
                    Spacer()
                    Button(action: {
                        
                    }){
                        Image(systemName: "dot.square")
                    }
                    Button(action: {
                        
                    }){
                        Image(systemName: "gearshape.fill")
                    }
                }
                .foregroundColor(grayLetter)
                .frame(height: 40)
                .padding(.top, 10)
                .padding(.horizontal, 10)
                .background(Color.white)
                
                Divider()
                
                TextField("", text: .constant(readedContent))
                    .font(scriptFonts[selectFontIdx].0)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(backColors[selectColorIdx])
                /*  책 내용  */
                
                
                
                Divider().padding(.bottom, 5)
                
                if !rollUp {
                    Button(action: {
                        withAnimation(){
                            rollUp.toggle()
                        }
                    }){
                        Image(systemName: "chevron.up").font(.system(size: 13)).foregroundColor(grayLetter)
                    }.padding(.bottom, 5)
                    .background(Color.white)
                }
                else{
                    VStack{
                        Button(action: {
                            withAnimation(.linear){
                                rollUp.toggle()
                            }
                        }){
                            Image(systemName: "chevron.down").font(.system(size: 13)).foregroundColor(grayLetter)
                        }.padding(.bottom, 10)
                        
                        RollUpMenuView(selectColorIdx: $selectColorIdx, selectFontIdx: $selectFontIdx)
                        
                        Text("\(curContent.readTime - count)")
                        
                        /* 속도 및 위치 */
                        HStack{
                            Text("속도").foregroundColor(grayLetter)
                            Spacer()
                            Slider(value: Binding(
                                get: {
                                    self.interval
                                },
                                set: {(newInterval) in
                                    self.interval = newInterval
                                    self.timer.connect().cancel()
                                    self.timer = Timer.publish(every: 1.1 - self.interval, on: .main, in: .common)
                                    self.timer.connect()
                                }
                            )).accentColor(usuallyColor)
                        }.padding() // 속도
                        HStack{
                            Text("위치: ")
                            Slider(value: Binding(
                                get: {
                                    self.place
                                },
                                set: {(newProgress) in
                                    self.place = newProgress
                                    self.curContent.readIdx = Int(newProgress * Double(self.curContent.fullContent.length))
                                    readedContent = self.curContent.fullContent.substring(toIndex: self.curContent.readIdx)
                                    self.count = Int(Double(curContent.readTime)*newProgress)
                                }
                            )).accentColor(usuallyColor)
                        }.padding() // 위치
                    }
                    .background(Color.white)
                    
                }
                
                /* 재생 및 넘어가기 */
                GeometryReader{ geometry in
                    HStack{
                        Spacer()
                        Button(action: {
                            
                        }){
                            Image(systemName: "backward.end.fill")
                        }
                        // 뒤로가기
                        Spacer()
                        Spacer()
                        Button(action: {
                            if self.isActive {
                                self.isActive = false
                            }
                            else {
                                self.timer.connect()
                                self.isActive = true
                            }
                        }){
                            if(self.isActive){
                                Image(systemName: "stop.fill")
                            }
                            else {
                                Image(systemName: "play.fill")
                            }
                        } // 재생 및 정지
                        Spacer()
                        Spacer()
                        Button(action: {
                            
                        }){
                            Image(systemName: "forward.end.fill")
                        }
                        // 앞으로가기
                        Spacer()
                    }
                    .frame(height: 60)
                    .foregroundColor(Color.white)
                    .background(usuallyColor)
                }
                .frame(height: 60).padding(.bottom, 30)
            }.onReceive(timer) { time in
                if isActive && curContent.readIdx < curContent.fullContent.length - 1{
                    self.count += 1
                    readedContent.append(curContent.fullContent[self.curContent.readIdx])
                    curContent.readIdx += 1
                    self.place = Double(curContent.readIdx+1) / Double(curContent.fullContent.length)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.isActive = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.isActive = true
            }//outer vstack
        }// outer zstack
        
        
    }//body
}//struct


struct RollUpMenuView: View {
    
    @Binding var selectColorIdx: Int
    @Binding var selectFontIdx: Int
    
    var body: some View {
        /* 배경색상 */
        HStack(spacing: 10) {
            ForEach(0...backColors.count-1, id: \.self) { colorIdx in
                Button(action: {
                    selectColorIdx = colorIdx
                }){
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(backColors[colorIdx])
                }
            }
        }.padding(.vertical, 10)
        
        Divider()
        /* 글꼴 */
        HStack{
            Text("글꼴").foregroundColor(grayLetter)
            Spacer()
            Button(action: {
                selectFontIdx -= 1
                if selectFontIdx < 0 {
                    selectFontIdx = scriptFonts.count - 1
                }
            }){
                Image(systemName: "chevron.backward")
                    .foregroundColor(grayLetter)
            }
            
            Text("\(scriptFonts[selectFontIdx].1)").foregroundColor(grayLetter)
            
            Button(action: {
                selectFontIdx += 1
                if selectFontIdx >= scriptFonts.count {
                    selectFontIdx = 0
                }
            }){
                Image(systemName: "chevron.right")
                    .foregroundColor(grayLetter)
            }
        }.padding()
        
        Divider()
        
    }
}
