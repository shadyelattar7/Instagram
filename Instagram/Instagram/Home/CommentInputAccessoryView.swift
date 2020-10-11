//
//  CommentInputAccessoryView.swift
//  Instagram
//
//  Created by Elattar on 5/12/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func submitComment(for comment: String)
}

class CommentInputAccessoryView: UIView{
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentText (){
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    fileprivate let commentTextView: commentInputTextView = {
        let tv = commentInputTextView()
//        tv.placeholder = "Enter Comment"
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    fileprivate let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sb.setTitleColor(.systemBlue, for: .normal)
        sb.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        //1
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white

        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, right: rightAnchor, bottom:  nil, paddingTop: 0, paddingLeft: 0, paddingRight: 12, paddingBottom: 0, width: 50, height: 50)
        
        addSubview(commentTextView)
        //3
        commentTextView.anchor(top: topAnchor, left: leftAnchor, right: submitButton.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 0, paddingBottom: 8, width: 0, height: 0)
        
        setupLineSeparetorView()
    }
    
    //2
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    fileprivate func setupLineSeparetorView(){
        let lineSeparetorView = UIView()
        lineSeparetorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparetorView)
        
        lineSeparetorView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0.5)
    }
    
    @objc func handleSendComment (){
        guard let commentText = commentTextView.text else {return}
        delegate?.submitComment(for: commentText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
