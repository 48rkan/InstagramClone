//
//  Constants.swift
//  Instagram
//
//  Created by Erkan Emir on 23.02.23.
//

import Firebase
import UIKit

//document snapshot -- anlik belgeler
// QueryDocumentSnapshot - anlik belge sorgusu

struct UserService {
    // bu yalniz movcud olan(1) useri bize verir.
    static func fetchUser(completion: @escaping (User)->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("user").document(uid).getDocument { documentSnapshot, error in
            
            guard let dictionary = documentSnapshot?.data() else { return }
            
            guard let password    = dictionary["password"]    as? String else { return }
            guard let email       = dictionary["email"]       as? String else { return }
            guard let fullname    = dictionary["fullname"]    as? String else { return }
            guard let username    = dictionary["username"]    as? String else { return }
            guard let profilimage = dictionary["profilimage"] as? String else { return }
            
            completion(User(email: email, password: password, fullname: fullname, username: username, profilimage: profilimage, uid: uid))
        }
    }
    
    static func fetchSelectedUser(userUid: String, completion: @escaping (User)->()) {
        
        Firestore.firestore().collection("user").document(userUid).getDocument { documentSnapshot, error in
            
            guard let dictionary = documentSnapshot?.data() else { return }
            
            guard let password    = dictionary["password"]    as? String else { return }
            guard let email       = dictionary["email"]       as? String else { return }
            guard let fullname    = dictionary["fullname"]    as? String else { return }
            guard let username    = dictionary["username"]    as? String else { return }
            guard let profilimage = dictionary["profilimage"] as? String else { return }
            
            completion(User(email: email, password: password, fullname: fullname, username: username, profilimage: profilimage, uid: userUid))
        }
    }
    
    static func fetchAllUsers(completion: @escaping ([User])->()) {
        var users = [User]()
        
        Firestore.firestore().collection("user").getDocuments { querySnapshot, error in
            
            querySnapshot?.documents.forEach({ queryDocumentSnapshot in
                
                let dictionary = queryDocumentSnapshot.data()
                print(dictionary)
                
                guard let password    = dictionary["password"]    as? String else { return }
                guard let email       = dictionary["email"]       as? String else { return }
                guard let fullname    = dictionary["fullname"]    as? String else { return }
                guard let username    = dictionary["username"]    as? String else { return }
                guard let profilimage = dictionary["profilimage"] as? String else { return }
                guard let uid         = dictionary["uid"]         as? String else { return }
                
                users.append(User(email: email, password: password, fullname: fullname, username: username, profilimage: profilimage,uid: uid))
            })
            completion(users)
        }
    }
    
    static func follow(uid: String,completion: @escaping (Error?)->()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        // following - takip etme(follow etmek)
        
        Firestore.firestore()
            .collection("following")
            .document(currentUid)
            .collection("user-following").document(currentUid).setData([:])
        
        
        Firestore.firestore()
            .collection("following")
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .setData([:]) { error in
                
                // followers - takipci
                Firestore.firestore()
                    .collection("followers")
                    .document(uid)
                    .collection("user-followers")
                    .document(currentUid)
                    .setData([:]) { error in
                        
                        
                        completion(error)
                    }
            }
    }
    
    static func unfollow(uid: String,completion: @escaping (Error?)->()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("following")
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete { error in
                
                Firestore.firestore()
                    .collection("followers")
                    .document(uid)
                    .collection("user-followers")
                    .document(currentUid)
                    .delete { error in
                        completion(error)
                    }
            }
        
    }
    
    static func checIfUserIsFollowed(uid: String,completion: @escaping (Bool)->()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore()
            .collection("following")
            .document(currentUid)
            .collection("user-following")
            .document(uid).getDocument { documentSnapshot, error in
                // exist-var demekdir.Bir seyin varligini ifade edir.Varsa true dondurur , yoxdursa false.
                
                guard let isFollowed = documentSnapshot?.exists else { return }
                completion(isFollowed)
            }
    }
    
    static func fetchUserStatistic(uid: String,completion: @escaping (UserStatistic)->()) {
        
        Firestore.firestore()
            .collection("following")
            .document(uid)
            .collection("user-following")
            .getDocuments { querySnapshot, error in
                let following = querySnapshot?.count ?? 0
                
                Firestore.firestore()
                    .collection("followers")
                    .document(uid)
                    .collection("user-followers")
                    .getDocuments { querySnapshot, error in
                        let followers = querySnapshot?.count ?? 0
                        
                        Firestore.firestore().collection("post").whereField("ownerUid", isEqualTo: uid).getDocuments { querySnapshot, error in
                            guard let postsCount = querySnapshot?.documents.count else { return }
                            
                            completion(UserStatistic(following: following, followers: followers,post: postsCount))
                            
                        }
                    }
            }
    }
}
