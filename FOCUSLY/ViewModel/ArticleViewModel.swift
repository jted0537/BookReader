//
//  ContentsViewModel.swift
//  FOCUSLY
//
//  Created by 정동혁 on 2021/02/09.
//

import Foundation
import Firebase

class ArticleViewModel: ObservableObject {
    @Published var article = [Article]()

    let formatter = DateFormatter()
    
    init() {
        //fetchArticle()
        formatter.dateFormat = "y-M-d"
    }

    func addArticle(articleTitle: String, fullLength: Int){
        guard let key = ref.childByAutoId().key else { return }
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(key)
        
        let newArticle : [String : Any] = [
                "id" : key,
                "articleTitle" : articleTitle,
                "createdDate" : formatter.string(from:
                Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()) ))!),
                "fullLength" : fullLength,
                "lastReadPostion" : 0,
            ]
        
        articleRef.setValue(newArticle, withCompletionBlock: { (error, ref) in
                if let err = error {
                    print(err.localizedDescription)
                }

                ref.observe(.value, with: { (snapshot) in
                    guard snapshot.exists() else {
                        return
                    }
                })
            })
    }
}

