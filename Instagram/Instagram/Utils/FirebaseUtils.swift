//
//  FirebaseUtils.swift
//  Instagram
//
//  Created by Elattar on 5/1/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import Firebase

extension Database{
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> Void){
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDic = snapshot.value as? [String:Any] else {return}
            let user = User(uid: uid, dictionary: userDic)
            
                completion(user)
            
        }) { (err) in
            print("Failed to fetch user post", err)
        }
    }
}
