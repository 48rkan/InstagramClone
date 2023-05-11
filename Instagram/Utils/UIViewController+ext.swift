//
//  UIViewController+ext.swift
//  Instagram
//
//  Created by Erkan Emir on 09.02.23.
//

import UIKit

extension UIViewController {
    
    func configGradientLayer() {
        let gradient: CAGradientLayer = {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.systemPurple.cgColor,UIColor.systemBlue.cgColor]
            gradient.locations = [0,1]
            
            
            view.layer.addSublayer(gradient)
            gradient.frame = view.frame
            
            return gradient
        }() 
    }
}
