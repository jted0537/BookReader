//
//  PreferenceView.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/01/22.
//

import SwiftUI
import Firebase

struct PreferenceView: View {
    @EnvironmentObject var FacebookLogin: FacebookDelegate
    @EnvironmentObject var GoogleLogin: GoogleDelegate
    let firebaseAuth = Auth.auth()
    
    var body: some View {
        Button(action: {
           do {
             try firebaseAuth.signOut()
            FacebookLogin.signedIn = false
            GoogleLogin.signedIn = false
           } catch let signOutError as NSError {
             print ("Error signing out: %@", signOutError)
           }
        }){
            Text("로그아웃")
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView()
    }
}
