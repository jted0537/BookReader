//
//  GoogleDelegate.swift
//  Based on Firebase sdk
//  DB reference: FirebasePractice
//
//  Created by 정동혁 on 2021/01/20.
//

import GoogleSignIn
import Firebase
import SwiftUI

// For Google Login
class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    @Published var userID: String = ""
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("signIn userID: " + authResult!.user.uid)
            self.userID = authResult!.user.uid
            self.signedIn = true
        }
    }
}
