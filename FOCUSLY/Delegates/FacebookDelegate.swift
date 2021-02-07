//
//  GoogleDelegate.swift
//  FirebasePractice
//
//  Created by 정동혁 on 2021/01/20.
//

import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftUI

// For Facebook Login
class FacebookDelegate: NSObject, LoginButtonDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    @Published var userID: String = ""
    let manager = LoginManager()
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) { }
    
    func logintWithFacebook (){
        manager.logIn(permissions: ["public_profile", "email"], from: nil){ (result, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            if !result!.isCancelled{

                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    print("SignIn userID : " + authResult!.user.uid)
                    self.userID = authResult!.user.uid
                    self.signedIn = true
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
}
