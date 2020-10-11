//
//  UserProfilePhotoCell.swift
//  Instagram
//
//  Created by Elattar on 4/24/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell{
    
    var post: Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(url: imageUrl)

        }
    }
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
