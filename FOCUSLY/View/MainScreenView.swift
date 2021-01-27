//
//  TabView.swift
//  SwiftPlaygroud
//
//  Created by 정동혁 on 2021/01/15.
//

import SwiftUI
import Firebase

/* Color Variables */
let gradationColor: Gradient = Gradient(colors: [Color(red: 1, green: 196/255, blue: 0), Color(red: 1, green: 147/255, blue: 0)])
let originalColor: Color = Color(red: 1, green: 176/255, blue: 0)
let usuallyColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)
let grayLetter: Color = Color(red: 96/255, green: 96/255, blue: 96/255)
let grayCircle: Color = Color(red: 238/255, green: 238/255, blue: 238/255)
let grayBox: Color = Color(red: 229/255, green: 229/255, blue: 229/255)
let mainColor: Color = Color(red: 245/255, green: 166/255, blue: 35/255)

/* Tab enum */
enum Tab{
    case Library
    case Folder
    case Statics
    case Preference
}

/* When Login Success */
struct MainScreenView: View {
    @State private var currentView: Tab = .Library
    @State private var selection = 0
    
    init() {
        /* NaviationBar Background */
        UINavigationBar.appearance().backgroundColor = UIColor(Color.white.opacity(0))
        UINavigationBar.appearance().isTranslucent = false
        /* NavigationBar foreground */
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(usuallyColor),
            .font : UIFont(name:"Papyrus", size: 40)!]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(usuallyColor),
            .font : UIFont(name: "HelveticaNeue-Thin", size: 20)!]
    }
    
    func trailingBarItems()-> some View {
        switch self.currentView{
        case .Library:
            return AnyView(NavigationLink(destination: MakeScriptView()){
                LinearGradient(gradient: gradationColor, startPoint: .top, endPoint: .bottom)
                    .mask(Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    ).frame(width: 30, height: 30)
            })
        case .Folder:
            return AnyView(Text("ddd"))
        case .Statics:
             return AnyView(Text("eeee"))
        case .Preference:
            return AnyView(Text("fffff"))
            
        }
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                switch self.currentView{
                case .Library:
                    MyLibraryView(user: User.generateUser(), currentView: self.$currentView)
                case .Folder:
                    Text("추천 글감")
                    Spacer()
                case .Statics:
                    Text("나의 보관함")
                    Spacer()
                case .Preference:
                    PreferenceView()
                    Spacer()
                }/* Each Tab Menu */
                TabBarView(currentView: self.$currentView) /* Tab bar */
            }.edgesIgnoringSafeArea(.bottom).navigationBarTitle(
                Text("FOCUSLY")
                , displayMode: .inline)
            .navigationBarItems(trailing: trailingBarItems())
        }.navigationViewStyle(StackNavigationViewStyle()) /* Outer Navigation View */
    }
}


/* Calling Tab bar */
struct TabBarView: View {
    @Binding var currentView: Tab
    
    var body: some View {
        Divider()
        HStack{
            TabBarItem(currentView: self.$currentView, imageName: "text.justifyleft", title: "나의서재",  tab: .Library)
            TabBarItem(currentView: self.$currentView, imageName: "folder.fill", title: "나의보관함",  tab: .Folder)
            TabBarItem(currentView: self.$currentView, imageName: "chart.bar.fill", title: "통계", tab: .Statics)
            TabBarItem(currentView: self.$currentView, imageName: "gearshape.fill", title: "환경설정", tab: .Preference)
        }
    }
}


/* Tab Bar UI */
struct TabBarItem: View {
    @Binding var currentView: Tab
    let imageName: String
    let title: String
    let tab: Tab
    
    var body: some View {
        
        VStack(alignment: .center){
            Image(systemName: imageName)
                .resizable()
                .frame(width: 24, height: 24, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(self.currentView == tab ? mainColor : grayLetter)
            
            if(self.currentView == tab){
                Text(title)
                    .font(.footnote)
                    .foregroundColor(mainColor)
            }
        }
        .padding(.horizontal, 10)
        .frame(width: 80, height: 60)
        .onTapGesture { withAnimation{
            self.currentView = self.tab
        }
        }
        .padding(.top, 5)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 20)
    }
}
