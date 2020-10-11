//
//  HomeController.swift
//  Instagram
//
//  Created by Elattar on 4/27/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate{
    
    var cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
            NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh (){
        posts.removeAll()
        fetchAllPosts()
        
    }
    
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowingUserIds ()
    }
    
    fileprivate func fetchFollowingUserIds (){

        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            
            userIdsDictionary.forEach { (key,value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostWithUser(user: user)
                }
            }
            
            
        }) { (err) in
            print("Failed to fetch user ID: ", err)
        }
        
        
    }
    
    
    fileprivate func setupNavigationItems(){
        
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "instalogo (3)"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "interface").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSendMessage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Camera").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
    }
    
    @objc func handleSendMessage (){
        print("handleSendMessage")
    }
    
    @objc func handleCamera(){
        print("handleCamera")
        
        let cameraController = CameraController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
    }
    
    fileprivate func fetchPosts(){

        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
        
    }
    
    
    fileprivate func fetchPostWithUser(user: User){

        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView.refreshControl?.endRefreshing()

            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach { (key,value) in
                
                guard let dictionary = value as? [String: Any] else {return}

                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    if let value = snapshot.value as? Int , value == 1 {
                        post.hasLike = true
                    }else {
                        post.hasLike = false
                    }
                    
                    self.posts.append(post)
                    
                    self.posts.sort { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    }
                    
                    self.collectionView.reloadData()

                }) { (err) in
                    print("failed to fetch post info",err)
                }
                
            }
      
        }) { (error) in
            print("Failed to fetch post " , error)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height  += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func didTapComment(post: Post) {
        print(post.caption)
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        guard let indexpath = collectionView.indexPath(for: cell ) else {return}
        var post = self.posts[indexpath.row]
//        print(post.caption)
        
        guard let postId = post.id else {return}
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let value = [uid: post.hasLike == true ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(value) { (err, _) in
            if let err = err {
                print("Failed to like post", err)
            }
            
            print("Successfully to like post")
            
            post.hasLike = !post.hasLike
            self.posts[indexpath.row] = post
            self.collectionView.reloadItems(at: [indexpath])
        }
        
        
    }
    
}
