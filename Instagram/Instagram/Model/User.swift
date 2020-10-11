//
//  User.swift
//  Instagram
//
//  Created by Elattar on 5/1/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import Foundation

struct User {
    
    
    let username: String
    let userProfileImage: String
    let uid: String
    
    init(uid: String, dictionary: [String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.userProfileImage = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = uid 
    }
}
