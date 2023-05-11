//
//  CustomTextField.swift
//  Instagram
//
//  Created by Erkan Emir on 09.02.23.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholderr: String,isSecureActive: Bool = false) {
        super.init(frame: .zero)
                
        self.borderStyle = .none
        self.isSecureTextEntry = isSecureActive
        self.attributedPlaceholder = NSMutableAttributedString(string: placeholderr ,attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.4) , .font: UIFont.boldSystemFont(ofSize: 13)])
        self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 10)
        leftView = spacer
        leftViewMode = .always
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
}
