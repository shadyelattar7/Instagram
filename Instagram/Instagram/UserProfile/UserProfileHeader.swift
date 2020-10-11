//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Elattar on 4/20/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}


class UserProfileHeader: UICollectionViewCell{
    
    var deleget: UserProfileHeaderDelegate?
    
    var user: User?{
        didSet{
             
            guard let profileImageUrl = user?.userProfileImage else {return}
            profileImageView.loadImage(url: profileImageUrl)
            usernameLabel.text = self.user?.username
            setupEditProfileButton()
        }
    }
    
    fileprivate func setupEditProfileButton() {
        
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid  else {return}
        
        if currentLoggedInUserId == userId{
            //Edit Pro file
             self.editProfileFollowButton.setTitle("Edit Profile", for: .normal)
            
        }else {
            
            //Check if follow or unfollow
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int , isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                
                }else{
                    self.setFollowStyle()
                }
                
                
            }) { (err) in
                print("Failed to check if following: ",err)
            }

        }
        
    }
    
    @objc func handleEditProfilerOrFollow (){
        //Execute editPrfoile / follow / unfollow logic ..
        print("Execute editPrfoile / follow / unfollow logic .. ")
    
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid  else {return}
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow"{
            // Unfollow logic
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
                if let err = err{
                    print("Failed to unfollowing: ", err)
                    
                }
                
                print("Successfully unfollow user", self.user?.username ?? "")
                
                self.setFollowStyle()
            }
            
        }else if editProfileFollowButton.titleLabel?.text == "Follow" {
            
            //Follow Logic
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let value = [userId: 1]
            
            ref.updateChildValues(value) { (err, ref) in
                if let err = err {
                    print("Failed to following this user", err)
                    return
                }else{
                    print("Successfully following user", self.user?.username ?? "")
                    
                    self.setUnfollowStyle()
                }
            }
        }else{
            print("EditProfile")
        }
    }
    
    fileprivate func setFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal )
        self.editProfileFollowButton.backgroundColor = UIColor .rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func setUnfollowStyle(){
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
    }
    
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        button.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.addTarget(self, action: #selector(changeToGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func changeToGridView (){
        print("button Grid")
        gridButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        deleget?.didChangeToGridView()
    }
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bullets"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleToChangeListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleToChangeListView (){
        print("button list")
        listButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        deleget?.didChangeToListView()
    }
    
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        
        return label
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
     //   button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor .lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfilerOrFollow), for: .touchUpInside)
        return button
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView )
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: self.leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.layer.masksToBounds = true
        
        
        setupToolbar()
        
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: gridButton.topAnchor, paddingTop: 4, paddingLeft: 20 , paddingRight: 20, paddingBottom: 0, width: 0, height: 0)
        
        setupStatsView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, right: followingLabel.rightAnchor, bottom: nil, paddingTop: 2 , paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 34)
        
    }
    
    fileprivate func setupStatsView(){
        let stackview = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        
        addSubview(stackview)
        
        stackview.anchor(top:safeAreaLayoutGuide.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor , bottom: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 12, paddingBottom: 0, width: 0, height: 50)
    }
    
    fileprivate func setupToolbar(){
        let stackview = UIStackView(arrangedSubviews: [gridButton,listButton,bookMarkButton])
        
        let topDiverView = UIView()
        topDiverView.backgroundColor = .lightGray
        
        let bottomDiverView = UIView()
        bottomDiverView.backgroundColor = .lightGray
        
        
        stackview.axis = .horizontal
        stackview.distribution = .fillEqually
        
        addSubview(stackview)
        addSubview(topDiverView)
        addSubview(bottomDiverView)

        
        stackview.anchor(top: nil, left: leftAnchor, right: rightAnchor , bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        
        topDiverView.anchor(top: stackview.topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
        
        
        bottomDiverView.anchor(top: stackview.bottomAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
        
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




