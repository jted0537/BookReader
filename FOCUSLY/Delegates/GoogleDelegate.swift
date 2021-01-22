//
//  GoogleDelegate.swift
//  FirebasePractice
//
//  Created by 정동혁 on 2021/01/20.
//

import GoogleSignIn
import Firebase
import SwiftUI

class GoogleDelegate: NSObject, GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    @Published var userEmail: String = ""
    
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
            print("signIn result: " + authResult!.user.email!)
            self.userEmail = authResult!.user.email!
            self.signedIn = true
        }
    }
}
