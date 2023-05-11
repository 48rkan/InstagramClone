//
//  CommentCellViewModel.swift
//  Instagram
//
//  Created by Erkan Emir on 17.04.23.
//

import Foundation
import UIKit

class CommentCellViewModel {
    
    let items: Comment
    
    init(items: Comment) {
        self.items = items
    }
    
    var imageURL: URL? { URL(string: items.userProfileImageUrl)}
    
    func configureLabel() -> NSMutableAttributedString {
        let firstText = NSMutableAttributedString(string: items.username ,attributes: [.font: UIFont.boldSystemFont(ofSize: 14),.foregroundColor: UIColor.black])
        
        let secondText = NSMutableAttributedString(string: " \(items.comment)" ,attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.black])
        
        firstText.append(secondText)
        
        return firstText
    }
}
