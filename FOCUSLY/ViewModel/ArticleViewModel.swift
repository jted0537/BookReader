//
//  ArticleViewModel.swift
//  purpose: managing viewmodel for user articles
//
//  Created by 정동혁 on 2021/02/09.
//

import Foundation
import Firebase

/* 현재 user의 article들을 관리해주는 viewmodel */
class ArticleViewModel: ObservableObject {
    // article들 저장
    @Published var article = [Article]()
    // 날짜 표시용 dateFormatter
    let formatter = DateFormatter()
    init() {
        formatter.dateFormat = "y-M-d"
    }
    
    // Fetch Article data from Database
    // Based on Firebase's Realtime Database
    func fetchArticle(){
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE")
        var articleList = [Article]()
        articleRef.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let placeDict = snap.value as! [String : Any]
                let articleTitle = placeDict["articleTitle"] as! String
                let article = placeDict["article"] as! String
                let createdDate = placeDict["createdDate"] as! String
                let lastReadPosition = placeDict["lastReadPosition"] as! Int
                
                articleList.append(Article(id: snap.key, articleTitle: articleTitle, article: article, createdDate: createdDate, lastReadPosition: lastReadPosition))
            }
            self.article = articleList
        })
    }
    
    // Add Article function
    // Based on Firebase's Realtime Database
    func addArticle(articleTitle: String, article: String, fullLength: Int){
        guard let key = ref.childByAutoId().key else { return }
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(key)
        
        let newArticle : [String : Any] = [
            "id" : key,
            "articleTitle" : articleTitle,
            "article" : article,
            "createdDate" : formatter.string(from:
                                                Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()) ))!),
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
    
    // Update Article function
    // Based on Firebase's Realtime Database
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
    // Based on Firebase's Realtime Database
    func removeArticle(articleIdx: Int) {
        let articleId = self.article[articleIdx].id
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(articleId)
        articleRef.removeValue()
    }
}

