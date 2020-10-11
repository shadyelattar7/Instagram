//
//  LoginController.swift
//  Instagram
//
//  Created by Elattar on 4/21/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController{
    
    
   
    let logoContnainrView: UIView = {
        let view = UIView()
        

        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
    
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 80, paddingRight: 80, paddingBottom: 0, width: 0 , height: 100)

        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    lazy var emailTextTextField: UITextField = {
           let tf = UITextField()
           tf.placeholder = "Email Address"
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
       
       @objc func  handleTextInputChange () {
           let isFormVaild = emailTextTextField.text?.count ?? 0 > 0  && passwordTextField.text?.count ?? 0 > 0
           
           if isFormVaild{
               logingButton.isEnabled = true
               logingButton.backgroundColor = UIColor .rgb(red: 17, green: 154, blue: 237)
           }else{
               logingButton.isEnabled = false
               logingButton.backgroundColor = UIColor .rgb(red: 149, green: 204, blue: 244)
               
           }
           
       }
       
       lazy var logingButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Log in", for: .normal)
           button.backgroundColor = UIColor .rgb(red: 149, green: 204, blue: 244)
           button.isEnabled = false
           button.layer.cornerRadius = 5
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
           button.setTitleColor(.white, for: .normal)
           button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
           return button
       }()
       
    @objc func handleLogin(){
        guard let email = emailTextTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Faild to sign in with email ", error.localizedDescription)
                return
            }
            
            print("Successfully log in with email" , user?.user.uid)
            
            guard let mainTabController =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            
            mainTabController.setupViewConroller()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    let siginUp: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),   NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor .rgb(red: 17, green: 154, blue: 237)]))
        
        
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSingUp), for: .touchUpInside)
        return button
        
    }()
    
    
    @objc fileprivate func handleShowSingUp(){
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(logoContnainrView)
        logoContnainrView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 150)
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        view.addSubview(siginUp)
        siginUp.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 50)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextTextField,passwordTextField,logingButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContnainrView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 65, paddingLeft: 40, paddingRight: 40, paddingBottom: 0, width: 0, height: 140)
        
        
    }

}
