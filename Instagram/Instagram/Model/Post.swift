//
//  Post.swift
//  Instagram
//
//  Created by Elattar on 4/24/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import Foundation

struct Post {
    var id: String?
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    var hasLike: Bool = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user 
        self.imageUrl = dictionary["imageURl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
