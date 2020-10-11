//
//  SearchCell.swift
//  Instagram
//
//  Created by Elattar on 5/1/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell{
    
    var user: User?{
        didSet{
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.userProfileImage else {return}
            userProfileImageView.loadImage(url: profileImageUrl)
        }
    }
    
    
    let userProfileImageView: CustomImageView = {
        let iv =  CustomImageView ()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        
        
        userProfileImageView.anchor(top: nil, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0 , paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 50, height: 50)
        userProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        userProfileImageView.layer.cornerRadius = 50 / 2
        userProfileImageView.clipsToBounds = true
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        let separetorView = UIView()
        separetorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separetorView)
        separetorView.anchor(top: nil, left: usernameLabel.leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
