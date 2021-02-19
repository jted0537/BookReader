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
    @State private var repeatedContent: String = "" // 구간반복 뷰 띄우기 용 텍스트
    @State private var repeatedFullContent: String = "" // 구간반복 전체 컨텐츠
    @State private var isRepeatMode: Bool = false // 구간반복 여부
    @State private var isHighlightSelect: Bool = false // 하이라이트 색 선택 창 띄울지 말지
    
    @State var cnt: Int = 0
    
    @Binding var curArticle: Article
    /* Custom Back Button Properties */
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    //@ObservedObject var articleViewModel = ArticleViewModel()
    
    /* Custom Back Button - leading */
    var btnBack : some View {
        Button(action: {
            if self.isRepeatMode {
                self.isActive = false
                self.isRepeatMode = false
            }
            else {
                self.mode.wrappedValue.dismiss()
            }
            
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
            if self.isRepeatMode {
                VStack{
                    MultilineTextView(text: self.$repeatedContent, selectFontIdx: $selectFontIdx, selectColorIdx: $selectColorIdx, isRepeatMode: self.$isRepeatMode, repeatContent: self.$repeatedFullContent)
                }
            }
            else {
                VStack{
                    MultilineTextView(text: self.$readedContent, selectFontIdx: $selectFontIdx, selectColorIdx: $selectColorIdx, isRepeatMode: self.$isRepeatMode, repeatContent: self.$repeatedFullContent)
                }
            }
            
            /* View of each Contents */
        
            // end of contents VStack
            
            /* Bottom bar */
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
                            Image(systemName: "chevron.up").font(.system(size: 15)).foregroundColor(grayLetter)
                        }.padding(.bottom, 5)
                    } /* When not roll up */
                    else{
                        VStack(spacing: 0){
                            Button(action: {
                                withAnimation(.easeIn){
                                    self.rollUp.toggle()
                                }
                            }){
                                Image(systemName: "chevron.down").font(.system(size: 15)).foregroundColor(grayLetter)
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
                                        self.cnt = Int(newProgress * Double(curArticle.article.length))
                                        self.curArticle.lastReadPosition = self.cnt
                                        self.readedContent = curArticle.article.substring(toIndex: curArticle.lastReadPosition)
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
                                self.timer.connect().cancel()
                                self.isActive = false
                            }
                            else {
                                self.timer = Timer.publish(every: (1.1 - self.interval)/7, on: .main, in: .common)
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
            self.readedContent = self.curArticle.article.substring(toIndex: self.cnt)
        }
        .onChange(of: self.isRepeatMode) { (newVal) in
            if newVal == false {
                self.repeatedContent = ""
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(curArticle.articleTitle)
        .navigationBarItems(leading: btnBack)
        .edgesIgnoringSafeArea(.vertical)
        .onReceive(self.timer) { time in
            if self.isActive && self.isRepeatMode {
                // 구간 반복 기능
                if self.repeatedContent.length < self.repeatedFullContent.length{
                    self.repeatedContent.append(self.repeatedFullContent[self.repeatedContent.length])
                }
                else if self.repeatedContent.length == self.repeatedFullContent.length {
                    self.repeatedContent = ""
                }
            }
            else if self.isActive && self.readedContent.length < self.curArticle.article.length {
                self.place = Double(curArticle.lastReadPosition+1) / Double(curArticle.article.length)
                readedContent.append(self.curArticle.article[self.cnt])
                self.cnt += 1
                self.curArticle.lastReadPosition = self.cnt
            }
        }
        
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
