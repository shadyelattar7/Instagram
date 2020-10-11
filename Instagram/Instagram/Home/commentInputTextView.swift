//
//  commentInputTextView.swift
//  Instagram
//
//  Created by Elattar on 5/12/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit

class commentInputTextView : UITextView{
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment"
        label.textColor = .lightGray
        return label
    }()
    
    func showPlaceholderLabel(){
        placeholderLabel.isHidden = false
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    @objc func handleTextChange (){
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
