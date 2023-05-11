//
//  AuthService.swift
//  Instagram
//
//  Created by Erkan Emir on 12.02.23.
//

// credentials - kimlik bilgileri

import UIKit
import Firebase

struct AuthCredential {
    var email: String
    var password: String
    var fullname: String
    var username: String
    var profileImage: UIImage
}

struct AuthService {
    
    static func logUserIn(email: String,password: String,completion: @escaping (AuthDataResult?,Error?) ->()) {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            completion(authDataResult,error)
        }
    }
    
    static func registerUser(credential: AuthCredential, completion: @escaping (Error?) -> ()) {
        
        ImageUploader.uploadImage(image: credential.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, error in
                if error != nil { return }

                guard let uid = result?.user.uid else { return }
                
                let data: [String:Any] = [
                    "email": credential.email,
                    "password": credential.password,
                    "fullname": credential.fullname,
                    "username": credential.username.lowercased(),
                    "profilimage": imageUrl,
                    "uid": uid
                ]
                
                Firestore.firestore().collection("user").document(uid).setData(data,completion: completion)
            }
        }
    }
}
