//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Erkan Emir on 26.02.23.
//

import Foundation

struct ProfileHeaderViewModel {
    
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var fullName: String { user.fullname }
    
    var profilimage: URL? { URL(string: user.profilimage ) }
    
    var buttonText: String {
        if user.isCurrentUser  {
            return "Edit profile"
        }
        
        return user.isFollowing ? "Following" : "Follow"
    }
    
    var followsValue: Int   { user.userStatistic?.following ?? 0 }
    
    var followersValue: Int { user.userStatistic?.followers ?? 0 }
    
    var postsValue: Int     { user.userStatistic?.post ?? 0 }

}
