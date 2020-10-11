//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Elattar on 4/20/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController , UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let login = LoginController()
                
                let navController = UINavigationController(rootViewController: login)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        
        setupViewConroller()
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if  index == 2{
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    func  setupViewConroller(){
        //Home
        let homeNavController = templateNavController(unSelectedImage: #imageLiteral(resourceName: "UnselectHome"), selectedIamge: #imageLiteral(resourceName: "SelectHome"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //Search
        let searchNavController = templateNavController(unSelectedImage: #imageLiteral(resourceName: "UnselectSearch"), selectedIamge: #imageLiteral(resourceName: "SelectSearch"),rootViewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //PLus
        let plusNavController = templateNavController(unSelectedImage: #imageLiteral(resourceName: "plus"), selectedIamge: #imageLiteral(resourceName: "plus"))
        
        //LikeNav
        let likeNavController = templateNavController(unSelectedImage: #imageLiteral(resourceName: "UnselectHeart"), selectedIamge: #imageLiteral(resourceName: "SelectHeart"))
        
        
        //UserProfile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "unselectUserProfiler")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "selectUserProfiler")
        
        
        //Custom TabBar
        tabBar.tintColor = .black
        viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController  ,userProfileNavController]
        
        //modfiy tab bar item insets
        guard let item = tabBar.items else {return}
        for item in item {
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
    }
    
    
    fileprivate func templateNavController (unSelectedImage: UIImage, selectedIamge: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unSelectedImage
        navController.tabBarItem.selectedImage = selectedIamge
        
        return navController
    }
    
}

