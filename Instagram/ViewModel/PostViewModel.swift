//
//  FeedCellViewModel.swift
//  Instagram
//
//  Created by Erkan Emir on 05.04.23.
//

import UIKit

class PostViewModel {
    var item: Post
    
    init(item: Post) {
        self.item = item
    }
    
    var likeButtonImage: UIImage? {
        item.liked ? UIImage(named: "like_selected") : UIImage(named: "like_unselected")
    }
    
    var postImageUrl: URL?     { URL(string: item.imageUrl) }
    
    var ownerImageUrl: URL?    { URL(string: item.ownerProfilImageUrl) }
    
    var ownerUserName: String? { item.ownerUserName }
    
    var description: String    { item.text }
    
    var imageUrl: URL?         { URL(string: item.imageUrl) }
    
    var likes: String { item.likes == 0 ? "\(item.likes) likes" : "\(item.likes) like" }
}
