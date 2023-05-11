//
//  NotificationService.swift
//  Instagram
//
//  Created by Erkan Emir on 03.05.23.
//

import Firebase

struct NotificationService {
    // 1. burda  fikir budur ki , biz notification'lari spesifik bir user'e gondermeliyik.Yeni user erkan99 profilindedirse bildirimler ona getmelidir.Ve yaxud basqasina elediyin bir actionun bildirimi de , ona getmelidir.
    static func uploadNotification(notificationOwnerUid uid: String,
                                   fromUser: User,
                                   notificationtype: NotificationType,
                                   post: Post? = nil) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if uid == currentUid { return }
        
        let dataRef = Firestore.firestore().collection("notifications").document(uid).collection("user-notifications").document()
        
        var data: [String:Any] = [
            "timestamp": Timestamp(date: Date()),
            "type": notificationtype.rawValue,
            "username": fromUser.username,
            "userProfilImageUrl": fromUser.profilimage,
            "uid": fromUser.uid,
            "documentID": dataRef.documentID
        ]
        
        if let post = post {
            data["postID"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        dataRef.setData(data)
    }
    
    static func fetchNotifications(completion: @escaping ([Notification])->()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("notifications").document(currentUid).collection("user-notifications").getDocuments { querySnapshot, _ in
            guard let documents = querySnapshot?.documents else { return }

            let notifications = documents.map({ Notification(dictionary: $0.data()) })
            completion(notifications)

        }
    }
}
