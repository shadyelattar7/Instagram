//
//  HomePostCell.swift
//  Instagram
//
//  Created by Elattar on 4/27/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell{
    
    var delegate: HomePostCellDelegate?
    
    var post: Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(url: imageUrl)
            
            guard  let profileImageUrl = post?.user.userProfileImage else {return}
            userProfileImageView.loadImage(url: profileImageUrl)
            usernameLabel.text = post?.user.username
            //  captionLable.text = post?.caption
            setupAttrubitedCaption()
            
            likeButton.setImage(post?.hasLike == true ? UIImage(named: "SelectHeart") : UIImage(named: "UnselectHeart") , for: .normal)
        }
    }
    
    
    fileprivate func setupAttrubitedCaption(){
        guard  let post = self.post else {return}
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray ]))
        
        captionLable.attributedText = attributedText
    }
    
    let userProfileImageView: CustomImageView = {
        let iv =  CustomImageView ()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let photoImageView: CustomImageView = {
        let iv =  CustomImageView ()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        
        return label
    }()
    
    let optionsButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()

    lazy var likeButton: UIButton = {
        let button  = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "UnselectHeart").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLike(){
        print("likce tapped")
        delegate?.didLike(for: self)
    }
    
    lazy var commentButton: UIButton = {
          let button  = UIButton(type: .system)
          button.setImage(#imageLiteral(resourceName: "chat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
          return button
      }()
    
    @objc func handleComment (){
        print("Comment")
        guard let post = post else {return}
        delegate?.didTapComment(post: post)
    }
    
    let sendMessageButton: UIButton = {
          let button  = UIButton(type: .system)
          button.setImage(#imageLiteral(resourceName: "interface").withRenderingMode(.alwaysOriginal), for: .normal)
          
          return button
      }()
    
    let bookmarkButton: UIButton = {
          let button  = UIButton(type: .system)
          button.setImage(#imageLiteral(resourceName: "bookmark").withRenderingMode(.alwaysOriginal), for: .normal)
          
          return button
      }()

    let captionLable: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
       
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, right: optionsButton.leftAnchor, bottom: photoImageView.topAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        optionsButton.anchor(top: topAnchor, left: nil, right: rightAnchor, bottom: photoImageView.topAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 44, height: 0)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 8, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionBUttons()
        
        addSubview(captionLable)
        captionLable.anchor(top: likeButton.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupActionBUttons(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackView.distribution = .fillEqually
        //stackView.spacing = 8
        
        addSubview(stackView)
        
        
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 4, paddingBottom: 0, width: 40, height: 50)
    }
    
}
