//
//  CommentCell.swift
//  Instagram
//
//  Created by Elattar on 5/6/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell{
    
    var comment: Comment? {
        didSet{
            
            guard let comment = comment else {return}
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSMutableAttributedString(string: " " + comment.text , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
            
            profileImageView.loadImage(url: comment.user.userProfileImage)
            
        }
    }
    
    let textView: UITextView = {
      let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.backgroundColor = .white
     return tv
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFit
       return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // backgroundColor = .systemYellow
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 4, paddingLeft: 4, paddingRight: 4, paddingBottom: 4, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
