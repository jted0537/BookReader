//
//  TempView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/25.
//
import SwiftUI

struct ContentsView: View {
    /* State Variables */
    @State var rollUp: Bool = false
    @State var selectColorIdx = 0
    @State var selectFontIdx = 0
    @State var count = 0
    @State var isActive = false
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
    @State var interval: Double = 0.5
    @State var place: Double = 0.0
    @State var readedContent: String=""
    
    /* Binding Variables */
    @Binding var curContent: Contents
    
    /* Custom Back Button Properties */
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    /* Custom Back Button - leading */
    var btnBack : some View {
        Button(action: {
            self.mode.wrappedValue.dismiss()
        }){
            HStack(spacing: 0) {
                Image(systemName: "arrow.left")
                    .foregroundColor(grayIcon)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    var body: some View {
        
        /* View of each Contents */
        ZStack{
            /* Setting Background Color */
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0){
                /* Contents Part */
                Text("\(readedContent)")
                //TextField("", text: .constant(readedContent))
                    .font(scriptFonts[selectFontIdx].0)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(backColors[selectColorIdx])
                
                
                Divider().padding(.bottom, 5)
                
                if !rollUp {
                    Button(action: {
                        withAnimation(){
                            rollUp.toggle()
                        }
                    }){
                        Image(systemName: "chevron.up").font(.system(size: 13)).foregroundColor(grayLetter)
                    }.padding(.bottom, 5)
                } /* When not roll up */
                else{
                    VStack{
                        Button(action: {
                            withAnimation(.linear){
                                rollUp.toggle()
                            }
                        }){
                            Image(systemName: "chevron.down").font(.system(size: 13)).foregroundColor(grayLetter)
                        }.padding(.bottom, 10)
                        
                        /* Roll up Menu */
                        RollUpMenuView(selectColorIdx: $selectColorIdx, selectFontIdx: $selectFontIdx)
                        
                        
                        
                        /*ddd*/
                        //Text("\(curContent.readTime - count)")
                        /*ddd*/
                        
                        
                        
                        /* Interval, Location */
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
                                    self.timer = Timer.publish(every: (1.1 - self.interval)/7, on: .main, in: .common)
                                    self.timer.connect()
                                }
                            )).accentColor(usuallyColor)
                        }.padding()
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
                        }.padding()
                    }
                    
                }/* when roll up */
                
                /* Play, Next, Prev */
                GeometryReader{ geometry in
                    HStack{
                        Spacer()
                        Button(action: {
                            
                        }){
                            Image(systemName: "backward.end.fill")
                        }
                        /* Prev */
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
                        }/* Play */
                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            
                        }){
                            Image(systemName: "forward.end.fill")
                        }
                        /* Next */
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
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(curContent.title)
        .navigationBarItems(leading: btnBack)
        .edgesIgnoringSafeArea(.top)
        
    }
}

/* RollUp Menu */
struct RollUpMenuView: View {
    
    @Binding var selectColorIdx: Int
    @Binding var selectFontIdx: Int
    
    var body: some View {
        /* BackGround Color */
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
        /* Setting Fonts */
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