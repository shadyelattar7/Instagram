//
//  Commnet.swift
//  Instagram
//
//  Created by Elattar on 5/6/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import Foundation


struct Comment {
    let user: User
    let text: String
    let uid: String
    
    init(user: User,dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
