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
    
    // Fetch Article data from Database
    func fetchArticle(){
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE")
        var articleList = [Article]()
        articleRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let placeDict = snap.value as! [String : Any]
                let articleTitle = placeDict["articleTitle"] as! String
                let createdDate = placeDict["createdDate"] as! String
                let fullLength = placeDict["fullLength"] as! Int
                let lastReadPosition = placeDict["lastReadPosition"] as! Int
                
                articleList.append(Article(id: snap.key, articleTitle: articleTitle, createdDate: createdDate, fullLength: fullLength, lastReadPosition: lastReadPosition))
            }
            self.article = articleList
        })
    }
    
    // Add Article function
    func addArticle(articleTitle: String, fullLength: Int){
        guard let key = ref.childByAutoId().key else { return }
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(key)
        
        let newArticle : [String : Any] = [
            "id" : key,
            "articleTitle" : articleTitle,
            "createdDate" : formatter.string(from:
                                                Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()) ))!),
            "fullLength" : fullLength,
            "lastReadPosition" : 0,
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
    
    // Update order of Article function
    func updateArticle() {
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE")
        articleRef.removeValue()
        var a = 0
        for articles in self.article {
            articleRef.child(articles.id).removeValue()
            let updatedArticle : [String : Any] = [
                "id" : articles.id,
                "articleTitle" : articles.articleTitle,
                "createdDate" : articles.createdDate,
                "fullLength" : articles.fullLength,
                "lastReadPosition" : articles.lastReadPosition,
            ]
            print(articles.articleTitle)
            //articleRef.child(articles.id).removeValue()

            articleRef.child(articles.id).setValue(updatedArticle, withCompletionBlock: { (error, ref) in
                if let err = error {
                    print(err.localizedDescription)
                }

                ref.observe(.value, with: { (snapshot) in
                    guard snapshot.exists() else {
                        return
                    }
                })
            })
            a+=1
            if a>2 { return }
        }
    }
    
    // Remove Article function
    func removeArticle(articleIdx: Int) {
        let articleId = self.article[articleIdx].id
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(articleId)
        articleRef.removeValue()
    }
    
}

