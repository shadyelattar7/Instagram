//
//  CommentController.swift
//  Instagram
//
//  Created by Elattar on 5/5/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout ,CommentInputAccessoryViewDelegate{

    
    var post: Post?
    let cellId = "CellId"
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        //     collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        navigationItem.title = "Comments"
        
        collectionView.backgroundColor = .white
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        
        fetchComments()
    }
    
    
    
    fileprivate func fetchComments(){
        
        guard let postId = self.post?.id else {return}
        
        let ref = Database.database().reference().child("comments").child(postId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            guard let uid = dictionary["uid"] as? String else {return}
            
            
            Database.fetchUserWithUID(uid: uid) { (user) in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
            
            
            
        }) { (err) in
            print("Failed to fetch comment: " ,err)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell =  CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    lazy var containerView: CommentInputAccessoryView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
        
    }()
    
    func submitComment(for comment: String) {
        print("Try to insert comment")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let postId = self.post?.id ?? ""
        let value = ["text": comment , "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child( postId).childByAutoId().updateChildValues(value) { (err, ref) in
            if let err = err{
                print("Failed to inserted comment",err)
                return
            }
            
            print("Successfully inserted comment.")
            self.containerView.clearCommentText()
        }
    }
    
    
    
// let commentText: UITextField = {
//      let textFiled = UITextField()
//      textFiled.placeholder = "Enter Comment"
//      return textFiled
//  }()
//
//    @objc func handleSendComment (){
//        //        print("Send button", commentText.text ?? "")
//        //        print("Post ID", self.post?.id)
//
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//
//        let postId = self.post?.id ?? ""
//        let value = ["text": commentText.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
//        Database.database().reference().child("comments").child( postId).childByAutoId().updateChildValues(value) { (err, ref) in
//            if let err = err{
//                print("Failed to inserted comment",err)
//                return
//            }
//
//            print("Successfully inserted comment.")
//        }
//    }
//
    override var inputAccessoryView: UIView?{
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}
