//
//  UserProfileController.swift
//  Instagram
//
//  Created by Elattar on 4/20/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
  
    
    let cellId = "cellId"
    var posts = [Post]()
    var userId: String? 
    var isGridView = true
    let homePostCellId = "homePostCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.title = "User Profile"
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register( UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        collectionView.alwaysBounceVertical = true

        fetchUser()
        setupLogOut()
    
    }
    
    var isFinishPaging = false
    
    fileprivate func paginatePosts(){
        print("Start paging for more posts")
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(uid)
        
//        let value = "-M6KM5x3nuUL9SLGRtyQ"
//        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 5)
       // var query = ref.queryOrderedByKey()
  
        var query = ref.queryOrdered(byChild: "creationDate")

        
        if posts.count > 0 {
//             let value = posts.last?.id
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObject = snapshot.children.allObjects as? [DataSnapshot] else {return}
//            print("Posts: \(allObject.count)")
            
            allObject.reverse()
            
            if allObject.count < 5 {
                self.isFinishPaging = true
            }
            
            if self.posts.count > 0  && allObject.count > 0{
                allObject.removeFirst()
            }
            
            allObject.forEach({ (snapshot) in
                print(snapshot.key)
                
                guard let user = self.user else {return}
                
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                
                self.posts.append(post)
            })
            
            self.posts.forEach { (post) in
                print(post.id ?? "")
            }
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to paginate posts:", err)
        }
    }
    
    fileprivate func fetchOrderPost(){
        
        guard let uid = self.user?.uid else {return}
 
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {return}
         
            
            guard let user = self.user else {return}
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)
            
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch order post " , err.localizedDescription)
        }
    }
    

    
    fileprivate func setupLogOut(){
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do{
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            }catch let signOutErr {
                print("Field to Sign Out",signOutErr)
            }
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // show yo how to fire off the paginate call
        if indexPath.row == posts.count - 1 && !isFinishPaging{
            print("Paginating for posts")
            paginatePosts()
        }
        
        
        
        if isGridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.row]
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }else {
            var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
            height  += view.frame.width
            height += 50
            height += 60
            
            return CGSize(width: view.frame.width, height: height)
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.deleget = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    var user: User?
    fileprivate func fetchUser(){
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
     //   guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            self.paginatePosts()
           // self.fetchOrderPost()

        }
        
    }
}


//MARK:- Change To Grid or List View
extension UserProfileController: UserProfileHeaderDelegate{
    func didChangeToListView() {
        isGridView = false
        collectionView.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView.reloadData()
    }

}
