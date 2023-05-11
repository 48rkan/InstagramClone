//
//  User.swift
//  Instagram
//
//  Created by Erkan Emir on 26.02.23.
//

import Foundation
import Firebase

struct User {
    var email: String
    var password: String
    var fullname: String
    var username: String
    var profilimage: String
    var uid: String
    
    var isFollowing = false
    
    var userStatistic: UserStatistic?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
}

struct UserStatistic {
    let following: Int
    let followers: Int
    let post: Int
}
