//
//  ContentView.swift
//  FirebasePractice
//
//  Created by 정동혁 on 2021/01/19.
//

import SwiftUI
import FBSDKLoginKit
import GoogleSignIn
import Firebase

struct LoginView: View {
    @EnvironmentObject var FacebookLogin: FacebookDelegate
    @EnvironmentObject var GoogleLogin: GoogleDelegate
    var body: some View {
//        if FacebookLogin.signedIn {
//            MainScreenView()
//        }
//        else if GoogleLogin.signedIn {
//            MainScreenView()
//        }
//        else {
//            SocialLoginView()
//        }
        MainScreenView()
    }
}

/* Login Interface */
struct SocialLoginView: View{
    @EnvironmentObject var GoogleLogin: GoogleDelegate
    @EnvironmentObject var FacebookLogin: FacebookDelegate
    
    var body: some View{
        VStack(spacing: 30){
            Image("focuslyImg").resizable().scaledToFit().frame(width:99, height:99).cornerRadius(15.0)
            Text("FOCUSLY").foregroundColor(Color(red: 1.0, green: 176/255, blue: 0.0)).bold().font(.system(.largeTitle, design: .rounded))
            
            /* Facebook Login */
            Button(action: {
                FacebookLogin.logintWithFacebook()
            }){
                HStack{
                    Image("Facebook")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width:24, height:24)
                        .cornerRadius(5)
                    Text("Facebook으로 로그인").foregroundColor(Color.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
            }
            .frame(width: 300, height: 50)
            .background(Color(red: 66/255, green: 103/255, blue: 178/255))
            .cornerRadius(60)
            .shadow(color: .secondary, radius: 0.7)
            
            /* Google Login */
            Button(action: {
                GIDSignIn.sharedInstance().signIn()
            }){
                HStack{
                    Image("Google")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width:24, height:24)
                    Text("Google로 로그인").foregroundColor(Color.black)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
            }
            .frame(width: 300, height: 50)
            .background(Color.white)
            .cornerRadius(60)
            .shadow(color: .secondary, radius: 0.7)
            
            /* Apple Login - not ready*/
        }
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}
