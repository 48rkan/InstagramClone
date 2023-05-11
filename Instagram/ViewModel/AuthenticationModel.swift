//
//  AuthenticationModel.swift
//  Instagram
//
//  Created by Erkan Emir on 10.02.23.
//

import UIKit

protocol UpdateFormProtocol {
    func updateForm()
}

protocol AuthProtocol {
    var formIsValid: Bool { get }
    var configBackgroundColor: UIColor { get }
}

struct LoginViewModel: AuthProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool { email?.isEmpty == false && password?.isEmpty == false }
    
    var configBackgroundColor: UIColor { formIsValid ? .brown : .systemPurple }
}

struct RegisterViewModel: AuthProtocol {
    var email: String?
    var password: String?
    var fullName: String?
    var userName: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullName?.isEmpty == false && userName?.isEmpty == false
    }
    
    var configBackgroundColor: UIColor { formIsValid ? .brown : .systemPurple }
}


struct ResetViewModel {
    var email: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    var configBackgroundColor: UIColor { formIsValid ? .brown : .systemPurple }
}
