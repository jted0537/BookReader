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

class FacebookDelegate: NSObject, LoginButtonDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    @Published var userEmail: String = ""
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
                    print("Facebook Sign In" + authResult!.user.email!)
                    self.userEmail = authResult!.user.email!
                    self.signedIn = true
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        try! Auth.auth().signOut()
    }
}

//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            print("Facebook Sign In"+authResult!.user.email!)
//        }
