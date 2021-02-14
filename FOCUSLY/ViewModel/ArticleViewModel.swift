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
    // just for test
    var article_content: String = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of 'de Finibus Bonorum et Malorum' (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, 'Lorem ipsum dolor sit amet..', comes from a line in section 1.10.32.\nThe standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from 'de Finibus Bonorum et Malorum' by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham."
    @Published var article_content_index = 0
    @Published var isRepeatMode: Bool = false
    @Published var repeatContent: String = ""
    @Published var highlightedContent = [UITextRange]()
    
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
    
    func turnOnRepeatMode(){
        self.isRepeatMode = true
    }
}

