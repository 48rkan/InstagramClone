//
//  CommentService.swift
//  Instagram
//
//  Created by Erkan Emir on 17.04.23.
//

import Foundation
import Firebase

struct CommentService {
    
    static func uploadComment(comments: String,postID: String,user: User,completion: @escaping (Error?)->()) {
        
        let data: [String:Any] = [
            "comment": comments,
            "timestamp": Timestamp(date: Date()),
            "userUid": user.uid,
            "username" : user.username,
            "userProfileImageUrl" : user.profilimage
        ]
        
        Firestore.firestore().collection("post")
            .document(postID)
            .collection("comments")
            .addDocument(data: data) { error in
                completion(error)
            }
    
    }
    
    static func fetchComments(postID: String,completion: @escaping (([Comment])->())) {
        Firestore.firestore()
            .collection("post")
            .document(postID).collection("comments")
            .order(by: "timestamp", descending: false)
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else { return }
                
                let comments = documents.map { queryDocumentSnapshot in
                    let dictionary = queryDocumentSnapshot.data()
                    print(dictionary)
                    return Comment(dictionary: dictionary)
                }
                completion(comments)
            }
    }
    
}
