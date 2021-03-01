//
//  ArticleViewModel.swift
//  purpose: managing viewmodel for user articles
//
//  Created by 정동혁 on 2021/02/09.
//

import Foundation
import Firebase

/* viewmodel for managing the current user's article */
class ArticleViewModel: ObservableObject {
    // save the articles into the current user model
    @Published var user = User()
    
    // DateFormatter for presenting the date
    let formatter = DateFormatter()
    init() {
        formatter.dateFormat = "y-M-d"
    }
    
    // Fetch article data from database
    // Based on firebase's realtime database
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
                
                // fetch the Highlight structs - need to be added
                
                articleList.append(Article(id: snap.key, articleTitle: articleTitle, article: article, createdDate: createdDate, lastReadPosition: lastReadPosition))
            }
            self.user.articles = articleList
        })
    }
    
    // Add article function
    // Based on firebase's realtime database
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
    
//<<<<<<< HEAD
//    // Update article function
//    // Based on firebase's realtime database
//    func updateArticle() {
//        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE")
//        articleRef.removeValue()
//        var a = 0
//        for articles in self.user.articles {
//            articleRef.child(articles.id).removeValue()
//            let updatedArticle : [String : Any] = [
//                "id" : articles.id,
//                "articleTitle" : articles.articleTitle,
//                "createdDate" : articles.createdDate,
//                "lastReadPosition" : articles.lastReadPosition,
//            ]
//            print(articles.articleTitle)
//            //articleRef.child(articles.id).removeValue()
//
//            articleRef.child(articles.id).setValue(updatedArticle, withCompletionBlock: { (error, ref) in
//                if let err = error {
//                    print(err.localizedDescription)
//                }
//
//                ref.observe(.value, with: { (snapshot) in
//                    guard snapshot.exists() else {
//                        return
//                    }
//                })
//            })
//            a+=1
//            if a>2 { return }
//        }
//=======
    // Update Article function
    // Based on Firebase's Realtime Database
    func updateArticlePosition(changedArticle: Article) {
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(changedArticle.id)
        let values = ["lastReadPosition": changedArticle.lastReadPosition]
        articleRef.updateChildValues(values)
        
    }
    
    // Remove Article function
    // Based on Firebase's Realtime Database
    func removeArticle(articleIdx: Int) {
        let articleId = self.user.articles[articleIdx].id
        let articleRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(articleId)
        articleRef.removeValue()
    }
    
    /* Not used */
    // Add Highlight struct to the given article
//    func addHighlight(article: Article, colorSelect: Int, highlightRange: NSRange) {
//        guard let highlightKey = ref.childByAutoId().key else { return }
//        let highlightRef = ref.child("USER").child("\(Auth.auth().currentUser!.uid)").child("ARTICLE").child(article.id).child("HIGHLIGHT").child(highlightKey)
//
//        let newHighlight : [String : Any] = [
//            "highlightKey" : highlightKey,
//            "color" : colorSelect,
//            "startPosition" : highlightRange.location,
//            "length" : highlightRange.length,
//        ]
//
//        highlightRef.setValue(newHighlight, withCompletionBlock: { (error, ref) in
//            if let err = error {
//                print(err.localizedDescription)
//            }
//
//            ref.observe(.value, with: { (snapshot) in
//                guard snapshot.exists() else {
//                    return
//                }
//            })
//        })
//
//    }
}

