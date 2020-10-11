//
//  SeachController.swift
//  Instagram
//
//  Created by Elattar on 5/1/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    let cellId = "cellId"
    var users = [User]()
    var filterusers = [User]()

    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.tintColor  = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {


        if searchText.isEmpty{
            filterusers = users
        }else{
            filterusers = users.filter({ (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            })
        }
        
     
        
        self.collectionView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.addSubview(searchBar)
        
        
        
        let navBar = navigationController?.navigationBar
        
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, bottom: navBar?.bottomAnchor, paddingTop: 0, paddingLeft: 8, paddingRight: 8, paddingBottom: 0, width: 0, height: 0)
        
        collectionView.register(SearchCell.self , forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    
    
    fileprivate func fetchUsers(){
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach { (key,value) in
                
                if key == Auth.auth().currentUser?.uid{
                    print("Found my self, omit in list")
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            }
            
            self.users.sort { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            }
            
            
            self.filterusers = self.users
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch users" , err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterusers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.user = filterusers[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let user = filterusers[indexPath.row]
        print(user.username)
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}
