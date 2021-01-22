////
////  GoogleDelegate.swift
////  FirebasePractice
////
////  Created by 정동혁 on 2021/01/20.
////
//
//import FBSDKCoreKit
//import FBSDKLoginKit
//import Firebase
//
//
//class FacebookDelegate: NSObject, LoginButtonDelegate, ObservableObject {
//    
//    @Published var signedIn: Bool = false
//    
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
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
//        signedIn = true
//    }
//    
//    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        try! Auth.auth().signOut()
//    }
//}
