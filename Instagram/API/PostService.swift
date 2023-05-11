//
//  PostService.swift
//  Instagram
//
//  Created by Erkan Emir on 22.03.23.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(image:UIImage,
                           text:String,
                           user: User,
                           completion: @escaping (Error?)->()) {
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let data : [String:Any] = [
                "image": imageUrl,
                "text" : text,
                "likes": 0,
                "time" : Timestamp(date: Date()),
                "ownerUid": uid,
                "ownerProfilImageUrl": user.profilimage,
                "ownerUserName": user.username,
                "liked": false
            ]
            Firestore.firestore().collection("post").addDocument(data: data) { error in
                completion(error)
            }
            
        }
    }
    
    static func fetchPosts(completion: @escaping ([Post])->()) {
        // descending - azalan sira
                
        Firestore.firestore().collection("post")
            .order(by: "time", descending: true)
            .getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            
            let posts = documents.map({ queryDocumentSnapshot in
                let dictionary = queryDocumentSnapshot.data()
                
                return Post(postId: queryDocumentSnapshot.documentID , dictionary: dictionary)
            })
            completion(posts)
        }
    }
    
    static func fetchOwnerUserPosts(userUid:String,completion: @escaping ( [Post])->()) {
        Firestore.firestore()
            .collection("post")
            .whereField("ownerUid", isEqualTo: userUid)
            .getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else { return }
                
                var posts = documents.map { Post(postId: $0.documentID , dictionary: $0.data()) }
                
                posts.sort { $0.time.seconds > $1.time.seconds }
                
                completion(posts)
            }
    }
    
    static func likePost(post: Post , completion: @escaping (Error?)->()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("post").document(post.postId).updateData(["likes": post.likes + 1 ])
        Firestore.firestore().collection("post").document(post.postId).updateData(["liked": true ])
        
        Firestore.firestore().collection("post").document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            
            Firestore.firestore().collection("user").document(uid).collection("user-likes").document(post.postId).setData([:]) { error in
                completion(error)
            }
        }
    }
    
    static func unLikePost(post: Post , completion: @escaping (Error?)->()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //condition qoyulmalidi 0 dan boyuk olsun
        
        Firestore.firestore().collection("post").document(post.postId).updateData(["likes": post.likes - 1 ])
        
        Firestore.firestore().collection("post").document(post.postId).updateData(["liked": false ])
        
        Firestore.firestore().collection("post").document(post.postId).collection("post-likes").document(uid).delete { _ in
            
            Firestore.firestore().collection("user").document(uid).collection("user-likes").document(post.postId).delete { error in
                completion(error)
            }
        }
    }
    
    static func checkPostIfLiked(post: Post , completion : @escaping (Bool)->()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("user").document(uid).collection("user-likes").document(post.postId).getDocument { documentSnapshot, error in
            guard let isLiked = documentSnapshot?.exists else { return }
            
            completion(isLiked)
        }
    }
    
    static func checkWhoIsLiked(post: Post,completion: @escaping ([User])->()) {
        
        var users = [User]()
        
        Firestore.firestore().collection("post").document(post.postId).collection("post-likes").getDocuments { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else { return }
            
            documents.forEach { queryDocumentSnapshot in
                let documentID = queryDocumentSnapshot.documentID
                
                UserService.fetchSelectedUser(userUid: documentID) { user in
                    users.append(user)
                    
                    completion(users)
                }
            }
        }
    }
    
    static func fetchSelectedPost(postID: String,completion: @escaping (Post)->()) {
        Firestore.firestore()
            .collection("post")
            .document(postID)
            .getDocument { snapshot, error in
                guard let snapshot = snapshot else { return }
                guard let dictionary = snapshot.data() else { return }
                completion(Post(postId: snapshot.documentID, dictionary: dictionary))
            }
    }
    
    static func fetchOnlyFollowingPosts(completion: @escaping ([Post])->()) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var posts = [Post]()
                
        Firestore.firestore().collection("following").document(currentUid).collection("user-following")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                documents.forEach { queryDocuments in
                    // uid - mene follow elediyim uid'leri verir
                    let uid = queryDocuments.documentID
                    
                    // burda ise hemin uid-i vererek butun post'larin icerisinden menim follow elediyim uid'lere sahib olan postlari gotururem ve onu doldurub gonderirem
                    Firestore.firestore().collection("post").whereField("ownerUid", isEqualTo: uid)
                        .getDocuments { snapshot, error in
                            guard let documents = snapshot?.documents else { return }
                            
                            documents.forEach { queryDocuments in
                                posts.append(Post(postId: queryDocuments.documentID, dictionary: queryDocuments.data()))
                            }
                            completion(posts)
                        }
                }
        }
    }
}
