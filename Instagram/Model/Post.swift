//
//  Post.swift
//  Instagram
//
//  Created by Erkan Emir on 05.04.23.
//

import Foundation
import Firebase

struct Post {
    let imageUrl: String
    var likes: Int
    let ownerUid: String
    var text : String
    var time: Timestamp
    let ownerProfilImageUrl: String
    let ownerUserName: String
    let postId: String
    var liked: Bool
    
    init(postId: String, dictionary: [String : Any]) {
        self.imageUrl = dictionary["image"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.ownerProfilImageUrl = dictionary["ownerProfilImageUrl"] as? String ?? ""
        self.ownerUserName = dictionary["ownerUserName"] as? String ?? ""
        self.liked = dictionary["liked"] as? Bool ?? false
        self.time = dictionary["time"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = postId
    }
}

