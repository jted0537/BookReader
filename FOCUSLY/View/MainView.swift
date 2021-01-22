//
//  TabView.swift
//  SwiftPlaygroud
//
//  Created by 정동혁 on 2021/01/15.
//

import SwiftUI

let gradationColor: Gradient = Gradient(colors: [Color(red: 1, green: 196/255, blue: 0), Color(red: 1, green: 147/255, blue: 0)])
let originalColor: Color = Color(red: 1, green: 176/255, blue: 0)
let usuallyColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
let grayLetter: Color = Color(red: 96/255, green: 96/255, blue: 96/255)
let grayCircle: Color = Color(red: 238/255, green: 238/255, blue: 238/255)
let mainColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)

/* 로그인시 보여질 View */
struct MainView: View {
    @State private var selection = 0
    
    //    init() {
    //        UITabBar.appearance().isTranslucent = false
    //    }
    var body: some View {
        VStack{
            TopBarView()
            
            
            TabView(selection: $selection){
                MyLibraryView(user: User.generateUser()).tabItem{
                    Image(systemName: "folder.fill")
                    Text("나의서재")
                }.tag(0)
                Text("추천글감").tabItem{
                    Image(systemName: "text.justifyleft")
                    Text("추천글감")
                }.tag(1)
                Text("3").tabItem{
                    Image(systemName: "chart.bar.fill")
                    Text("나의보관함")
                }.tag(2)
                Text("4").tabItem{
                    Image(systemName: "gearshape.fill")
                    Text("환경설정")
                }.tag(3)
            }.accentColor(mainColor)
        }
    }
} //Main화면 View, Tab View

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct TopBarView: View {
    
    @State var plusPressed: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack{
                    if !self.plusPressed {
                        HStack(spacing: 0){
                            Text("").frame(width: geometry.size.width/6)
                            Text("FOCUSLY").foregroundColor(originalColor).bold().font(.title2).frame(width: geometry.size.width*2/3)
                            Button(action: {
                                withAnimation{
                                    self.plusPressed.toggle()
                                }
                            }){
                                LinearGradient(gradient: gradationColor, startPoint: .top, endPoint: .bottom)
                                    .mask(Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    ).frame(width:24, height: 24)
                                
                            }.frame(width: geometry.size.width/6)
                            
                        }
                    }
                    else {
                        HStack(spacing: 0){
                            Button( action: {
                                withAnimation{
                                    self.plusPressed.toggle()
                                }
                            }){
                                Image(systemName: "backward.end")
                            }.frame(width: geometry.size.width/8)
                            Spacer()
                            Button(action: {
                                
                            }){
                                Image(systemName: "pencil")
                            }.frame(width: geometry.size.width/8)
                            
                            Button(action: {
                                
                            }){
                                Image(systemName: "camera")
                            }.frame(width: geometry.size.width/8)
                            
                            Button(action: {
                                
                            }){
                                Image(systemName: "paperclip")
                            }.frame(width: geometry.size.width/8)
                        }
                    }
                }.frame(height:30).padding(.bottom, 10)
                Divider()
            }
        }.frame(height: 50)
    }
}
