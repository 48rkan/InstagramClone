//
//  NotificationCellViewModel.swift
//  Instagram
//
//  Created by Erkan Emir on 03.05.23.
//

import UIKit

class NotificationCellViewModel {
    var items: Notification
    
    init(items: Notification) {
        self.items = items
    }

    var profilImageUrl: URL? { URL(string: items.userProfilImageUrl) }
    
    var postImageUrl: URL? { URL(string: items.postImageUrl ?? "") }

    var descriptionAttributedText: NSMutableAttributedString {
        let firstText = NSMutableAttributedString(string: items.username ,attributes: [.font: UIFont.boldSystemFont(ofSize: 14),.foregroundColor: UIColor.black])
        firstText.append( NSAttributedString(string: items.type.notificationMessage, attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.black]))
        firstText.append( NSAttributedString(string: " 2m", attributes: [.font: UIFont.systemFont(ofSize: 12),.foregroundColor: UIColor.lightGray]))

        return firstText
    }
    
    var followButtonTitle: String { items.userIsFollowed ? "Following" : "Follow" }
    
    var followButtonBackgroundColor: UIColor {
        items.userIsFollowed ? .systemBlue  : .white
    }
    
    var followButtonTintColor: UIColor {
        items.userIsFollowed ? .white : .black
    }
    
    var shouldHide: Bool { items.type == .follow }
}
