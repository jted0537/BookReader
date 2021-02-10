//
//  TabView.swift
//  SwiftPlaygroud
//
//  Created by 정동혁 on 2021/01/15.
//

import SwiftUI
import Firebase

// Tab enum
enum Tab{
    case Library
    case Folder
    case Statics
    case Preference
}

// When Login Success
struct MainScreenView: View {
    @State private var currentView: Tab = .Library
    
    init() {
        // NaviationBar Background
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().isTranslucent = false
        // NavigationBar foreground
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(usuallyColor),
            .font : UIFont(name: "Calibri", size: 40)!]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(usuallyColor),
            .font : UIFont(name: "Calibri", size: 20)!]
    }
    
    // For topTrailing Plus Button functions
    var trailingBarItems: some View {
        VStack{
            switch self.currentView{
            case .Library:
                NavigationLink(destination: MakeContentsView()){
                    plusButton()
                } /* Make own Contents */
            case .Folder:
                textFieldAlert()
            /* Make Folder Alert */
            case .Statics:
                plusButton()
            case .Preference:
                plusButton()
            }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                switch self.currentView{
                case .Library:
                    MyLibraryView()
                case .Folder:
                    Text("추천 글감")
                    Spacer()
                case .Statics:
                    Text("나의 보관함")
                    Spacer()
                case .Preference:
                    PreferenceView()
                    Spacer()
                }// Each Tab Menu
                TabBarView(currentView: self.$currentView) /* Tab bar */
            }.edgesIgnoringSafeArea(.bottom).navigationBarTitle(
                Text("FOCUSLY")
                , displayMode: .inline)
            .navigationBarItems(trailing: trailingBarItems)
        }.navigationViewStyle(StackNavigationViewStyle()) /* Outer Navigation View */
    }
}

// Calling Tab bar
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

// Tab Bar UI
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

// Custom Alert Message with TextField
struct textFieldAlert: View {
    @State private var newFolder: String? = ""
    
    // Customizing Alert Message Part
    private func alert() {
        let alert = UIAlertController(title: "새로운 폴더 추가", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "폴더 이름"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in })
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.newFolder = alert.textFields?[0].text
            if let folderName = self.newFolder {
                // When FolderName is available
                if folderName.count != 0 {
                    print("\(folderName)!!")
                }
                // When Not
                else {
                    print("fail")
                }
            }
        })
        showAlert(alert: alert)
    }
    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .compactMap {$0 as? UIWindowScene}
            .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }
    
    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    var body: some View {
        VStack{
            Button(action: {
                self.alert()
            }) {
                plusButton()
            }
        }
    }
}

/* Plus Button UI */
struct plusButton: View {
    var body: some View {
        LinearGradient(gradient: gradationColor, startPoint: .top, endPoint: .bottom)
            .mask(Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            ).frame(width: 30, height: 30)
    }
}

