//
//  PreviewPhotoContainerView.swift
//  Instagram
//
//  Created by Elattar on 5/4/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import Photos
class PreviewPhotoContainerView : UIView{
    
    let previewImageView : UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.addTarget(self, action: #selector(handleCancelBtn), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrows (1)"), for: .normal)
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancelBtn (){
        self.removeFromSuperview()
    }
    
    @objc func handleSavePhoto (){
        
        guard let previewImage = previewImageView.image else {return}
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("Failed to save photo ", err)
                return
            }
            
            print("Successfully save image to library ")
            
            DispatchQueue.main.async {
                let saveLabel = UILabel()
                saveLabel.text = "Save Successfully"
                saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
                saveLabel.textAlignment = .center
                saveLabel.textColor = .white
                saveLabel.numberOfLines = 0
                saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                
                saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                saveLabel.center = self.center
                self.addSubview(saveLabel)
                
                saveLabel.layer.transform = CATransform3DMakeScale(0,0,0)

                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                    
                }) { (completed) in
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        saveLabel.alpha = 0
                        
                    }) { (_) in
                        
                        saveLabel.removeFromSuperview()
                        
                    }
                }
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, right: nil, bottom: nil, paddingTop: 12, paddingLeft: 12, paddingRight: 0, paddingBottom: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, right: nil, bottom: bottomAnchor, paddingTop: 0 , paddingLeft: 24, paddingRight: 0, paddingBottom: 24, width: 50, height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
