//
//  ext.swift
//  Instagram
//
//  Created by Erkan Emir on 17.04.23.
//

import UIKit

extension UIViewController {
    
    func dynamicHeightCalculator(text: String,width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}


