//
//  PreferenceView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/22.
//

import SwiftUI
import Firebase

/* Preference(Setting) */
struct PreferenceView: View {
    @EnvironmentObject var FacebookLogin: FacebookDelegate
    @EnvironmentObject var GoogleLogin: GoogleDelegate
    
    /*Disconnect Firebase */
    let firebaseAuth = Auth.auth()
    
    var body: some View {
        VStack(spacing: 20) {
            if FacebookLogin.signedIn {
                Text("\(FacebookLogin.userEmail)님 안녕하세요!")
            }
            else if GoogleLogin.signedIn {
                Text("\(GoogleLogin.userEmail)님 안녕하세요!")
            }
            Button(action: {
               do {
                 try firebaseAuth.signOut()
                FacebookLogin.signedIn = false
                GoogleLogin.signedIn = false
               } catch let signOutError as NSError {
                 print ("Error signing out: %@", signOutError)
               }
            }){
                Text("로그아웃").foregroundColor(usuallyColor)
            }/* Logout Button */
            Spacer()
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
