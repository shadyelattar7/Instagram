//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Elattar on 4/22/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase
class SharePhotoController: UIViewController{
    
    var selectedImage: UIImage?{
        didSet{
            self.imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .red
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor .rgb(red: 240, green: 240, blue: 240)
        
        setupSharebtn()
        setupImageAndTextViews ()
    }
    
    
    fileprivate func  setupImageAndTextViews (){
        let containrView = UIView()
        containrView.backgroundColor = .white
        
        view.addSubview(containrView)
        
        containrView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 100)
        
        containrView.addSubview(imageView)
        
        imageView.anchor(top: containrView.topAnchor, left: containrView.leftAnchor, right: nil, bottom: containrView.bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 8, width: 84, height: 0)
        
        containrView.addSubview(textView)
        textView.anchor(top: containrView.topAnchor, left: imageView.rightAnchor, right: containrView.rightAnchor, bottom: containrView.bottomAnchor, paddingTop: 0, paddingLeft: 4, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    fileprivate func  setupSharebtn(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    @objc func handleShare(){
        guard let caption = textView.text , caption.count > 0 else {return}
        
        guard let image = selectedImage else {return}
        
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("posts").child(fileName)
        
        ref.putData(uploadData, metadata: nil) { (metaData, error) in
            if let error = error{
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                print("Faild to post image ", error.localizedDescription)
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error{
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let ImageUrl = url?.absoluteString else {
                    print("Error: Somthing wrong When to Get URl Image")
                    return
                }
                
                print("Sccuessfully Upload  Picture, \(ImageUrl)")
                self.saveToDatabaseWithImageUrl(imageUrl: ImageUrl)
            }
            
        }
    }
    
   static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")

    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String){
        guard let caption = textView.text else {return}
        guard let postImage = selectedImage else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        let userRef = Database.database().reference().child("posts").child(uid)
        
        let ref =   userRef.childByAutoId()
        let vaule = ["imageURl":imageUrl, "caption": caption, "imageWidth": postImage.size.width,"imageHeigth": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any] 
        ref.updateChildValues(vaule) { (error, ref) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true

                print("Failed to save post image to DB", error.localizedDescription)
                return
            }
            
            print("Successfully save post image to DB")
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
            
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}
