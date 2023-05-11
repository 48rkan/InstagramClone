//
//  Comment.swift
//  Instagram
//
//  Created by Erkan Emir on 17.04.23.

import Foundation
import Firebase

struct Comment {
    let comment: String
    let userUid: String
    let username: String
    let userProfileImageUrl: String
    let timestamp: Timestamp
    
    init(dictionary: [String:Any]) {
        self.comment = dictionary["comment"] as! String
        self.userUid = dictionary["userUid"] as! String
        self.username = dictionary["username"] as! String
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as! String
        self.timestamp = dictionary["timestamp"] as! Timestamp
    }
}

