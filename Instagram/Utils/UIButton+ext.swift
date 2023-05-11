//
//  UIButton+ext.swift
//  Instagram
//
//  Created by Erkan Emir on 09.02.23.
//

import UIKit

extension UIButton {
    func setButtonConfiguration(firstText: String, secondText: String) {

        let firstTitle = NSMutableAttributedString(string: "\(firstText)",attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.4) , .font: UIFont.boldSystemFont(ofSize: 13)])
        
        let secondTitle = NSMutableAttributedString(string: "\(secondText)",attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.4) , .font: UIFont.boldSystemFont(ofSize: 13)])
        
        firstTitle.append(secondTitle)
        
        self.setAttributedTitle(firstTitle, for: .normal)
    }
}
