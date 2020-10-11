//
//  ViewController.swift
//  Instagram
//
//  Created by Elattar on 4/19/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpController: UIViewController {
    
    lazy var plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cameraAddPhoto").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(hendlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func hendlePlusPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    lazy var emailTextTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func  handleTextInputChange () {
        let isFormVaild = emailTextTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0  && passwordTextField.text?.count ?? 0 > 0
        
        if isFormVaild{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor .rgb(red: 17, green: 154, blue: 237)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor .rgb(red: 149, green: 204, blue: 244)
            
        }
        
    }
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "User Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor .rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleSignUp (){
        guard let email = emailTextTextField.text,email.count > 0 else {
            print("Email is Empty")
            return
        }
        guard let userName = userNameTextField.text , userName.count > 0  else {
            print("UserName is Empty")
            return
        }
        guard let password = passwordTextField.text , password.count > 0  else {
            print("Password is Empty")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("error: \(error.localizedDescription)")
                return
            }else{
                print("Sign Up is Sccuess")
                
                guard let image = self.plusPhotoButton.imageView?.image else {return}
                guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
                
                let fileName = NSUUID().uuidString
                
                let ref = Storage.storage().reference().child("profile_images").child(fileName)
                
                ref.putData(uploadData, metadata: nil) { (metaData, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    ref.downloadURL { (url, error) in
                        if let error = error{
                            print("Error: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let profileImageUrl = url?.absoluteString else {
                            print("Error: Somthing wrong When to Get URl Image")
                            return
                        }
                        
                        print("Sccuessfully Upload Profile Picture, \(profileImageUrl)")
                        
                        guard let uid = user?.user.uid else {return}
                        let dictionaryValuse: [String: Any] = ["username": userName, "profileImageUrl": profileImageUrl]
                        let value = [uid: dictionaryValuse]
                        Database.database().reference().child("users").updateChildValues(value) { (error, ref) in
                            if let error = error{
                                print("Error: \(error.localizedDescription)")
                                return
                            }else {
                                print("Successfully saved user info to db")
                                
                                  guard let mainTabController =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                                  
                                  mainTabController.setupViewConroller()
                                  self.dismiss(animated: true, completion: nil)
                            }
                        }
                        
                    }
                    
                }
                
                
                
            }
        }
    }
    
    
    let login: UIButton = {
           let button = UIButton(type: .system)
           
           let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),   NSAttributedString.Key.foregroundColor: UIColor.lightGray])
           
           attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor .rgb(red: 17, green: 154, blue: 237)]))
           
           
           
           button.setAttributedTitle(attributedTitle, for: .normal)
           button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
           return button
           
       }()
       
       
       @objc fileprivate func handleShowLogin(){
           navigationController?.popViewController(animated: true)
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)
        view.backgroundColor = .white
        
        //        NSLayoutConstraint.activate([
        //            plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
        //            plusPhotoButton.heightAnchor.constraint(equalToConstant: 100),
        //            plusPhotoButton.widthAnchor.constraint(equalToConstant: 100),
        //        ])
        
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 40, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 150, height: 150)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(login)
        login.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        
        
        setupInputFields()
        
    }
    
    
    
    fileprivate func setupInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextTextField,userNameTextField,passwordTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 20, paddingLeft: 40, paddingRight: 40, paddingBottom: 0, width: 0, height: 200)
        
        
    }
    
    
}



extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let editImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            plusPhotoButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }else if let selectImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            plusPhotoButton.setImage(selectImg.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 1
        picker.dismiss(animated: true, completion: nil)
    }
}
