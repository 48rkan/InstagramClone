//
//  SearchViewModel.swift
//  Instagram
//
//  Created by Erkan Emir on 28.02.23.
//

import Foundation

struct SearchViewModel {
    
    let users: User
    
    init(users: User) {
        self.users = users
    }
    
    var fullName: String { users.fullname }
    
    var userName: String { users.username  }
    
    var profilImageURL: URL? { URL(string: users.profilimage) }
 
}
