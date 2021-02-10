//
//  TempView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/25.
//
import SwiftUI


struct ArticleView: View {
    /* State Variables */
    @State private var rollUp: Bool = false
    @State private var selectColorIdx = 0
    @State private var selectFontIdx = 0
    @State private var count = 0
    @State private var isActive = false
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
    @State private var interval: Double = 0.5
    @State private var place: Double = 0.0
    @State private var readedContent: String = ""
    
    @State var curArticle: Article
    /* Custom Back Button Properties */
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    @ObservedObject var contentsViewModel = ArticleViewModel()
    
    func nextContents() {
        
        
    }
    
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
        ZStack{
            /* View of each Contents */
            VStack(spacing: 0){
                /* Contents Part */
                MultilineTextView(text: $readedContent, selectFontIdx: $selectFontIdx, selectColorIdx: $selectColorIdx)
                
            }
            .background(Color.background)
            // end of contents VStack
            
            VStack(){
                Spacer()
                VStack{
                    Divider().padding(.bottom, 5)
                    
                    if !self.rollUp {
                        Button(action: {
                            withAnimation(.easeIn){
                                self.rollUp.toggle()
                            }
                        }){
                            Image(systemName: "chevron.up").font(.system(size: 20)).foregroundColor(grayLetter)
                        }.padding(.bottom, 5)
                    } /* When not roll up */
                    else{
                        VStack(spacing: 0){
                            Button(action: {
                                withAnimation(.easeIn){
                                    self.rollUp.toggle()
                                }
                            }){
                                Image(systemName: "chevron.down").font(.system(size: 20)).foregroundColor(grayLetter)
                            }.padding(.bottom, 5)
                            
                            /* Roll up Menu */
                            RollUpMenuView(selectColorIdx: $selectColorIdx, selectFontIdx: $selectFontIdx)
                            
                            /* Interval, Location */
                            HStack{
                                Text("속도 ").foregroundColor(grayLetter)
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
                            }.padding([.top, .horizontal]) /* Interval */
                            HStack{
                                Text("위치 ").foregroundColor(grayLetter)
                                Slider(value: Binding(
                                    get: {
                                        self.place
                                    },
                                    set: {(newProgress) in
                                        self.place = newProgress
                                        curArticle.lastReadPosition = Int(newProgress * Double(curArticle.fullLength))
                                       // self.readedContent = curArticle.fullContent.substring(toIndex: curArticle.lastReadPosition)
                                        //self.count = Int(Double(curContent.readTime)*newProgress)
                                    }
                                )).accentColor(usuallyColor)
                            }.padding() /* Location */
                        }
                    }/* when roll up */
                    
                    /* Play, Next, Prev */
                    HStack{
                        Spacer()
                        Button(action: {
                            
                        }){
                            Image(systemName: "backward.end.fill")
                        }/* Prev */
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
                        }/* Next */
                        Spacer()
                    }
                    .frame(height: 55)
                    .foregroundColor(Color.white)
                    .background(usuallyColor)
                    .padding(.bottom, 30)
                }
                .background(Color.background)
                
            }
            
        }
        .onAppear() {
            //self.readedContent = self.curArticle.fullContent.substring(toIndex: curArticle.lastReadPosition)
        }
        .onReceive(self.timer) { time in
            if self.isActive && curArticle.lastReadPosition < curArticle.fullLength - 1{
                self.count += 1
                //readedContent.append(curArticle.fullContent[curArticle.lastReadPosition])
                self.curArticle.lastReadPosition += 1
                //self.place = Double(curArticle.lastReadPosition+1) / Double(curArticle.fullContent.length)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(curArticle.articleTitle)
        .navigationBarItems(leading: btnBack)
        .edgesIgnoringSafeArea(.vertical)
        
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
                    self.selectColorIdx = colorIdx
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
                self.selectFontIdx -= 1
                if self.selectFontIdx < 0 {
                    self.selectFontIdx = scriptFonts.count - 1
                }
            }){
                Image(systemName: "chevron.backward")
                    .foregroundColor(grayLetter)
            }
            
            Text("\(scriptFonts[self.selectFontIdx].1)").foregroundColor(grayLetter)
            
            Button(action: {
                self.selectFontIdx += 1
                if self.selectFontIdx >= scriptFonts.count {
                    self.selectFontIdx = 0
                }
            }){
                Image(systemName: "chevron.right")
                    .foregroundColor(grayLetter)
            }
        }.padding()
        
        Divider()
        
    }
}