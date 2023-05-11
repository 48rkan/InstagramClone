//
//  CommentsAccesoryView.swift
//  Instagram
//
//  Created by Erkan Emir on 11.04.23.
//

import UIKit

protocol CommentsAccesoryViewDelegate: AnyObject {
    func afterTappedPostButton(accesoryView: CommentsAccesoryView,commentText: String)
}

class CommentsAccesoryView: UIView {
    
    weak var delegate: CommentsAccesoryViewDelegate?
    
    //MARK:- Properties
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
//        textView.backgroundColor = .lightGray
        
        return textView
    }()
    
    private let customPlaceholder: UILabel = {
        let placeholder = UILabel()
        placeholder.font = UIFont(name: "Helvetica Neue", size: 16)
        placeholder.text = "Entered comment..."
        placeholder.textColor = .lightGray
        return placeholder
    }()
    
    private lazy var postButton: UIButton = {
        let b = UIButton()
        b.setTitle("Post", for: .normal)
        b.setTitleColor(UIColor.black, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        b.addTarget(self, action: #selector(clickedPost), for: .touchUpInside)
        
        return b
    }()
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been ") }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI() {
        backgroundColor = .white
        
        let spacer = UIView()
        addSubview(spacer)
        spacer.backgroundColor = .lightGray
        spacer.anchor(top: topAnchor,left: leftAnchor,right: rightAnchor)
        spacer.setDimensions(height: 0.5, width: frame.width)
        
        addSubview(postButton)
        postButton.anchor(top: spacer.bottomAnchor,right: rightAnchor,paddingTop: 8,paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(textView)
        textView.anchor(top: spacer.bottomAnchor,left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: postButton.leftAnchor,paddingTop: 4,paddingLeft: 4,paddingBottom: 4,paddingRight: 4)
        
        textView.addSubview(customPlaceholder)
        customPlaceholder.anchor(top: textView.topAnchor,left: textView.leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlaceholder), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    //MARK:- Actions
    
    func clearComments() {
        textView.text = nil
        customPlaceholder.isHidden = false
    }
    
    @objc func clickedPost() {
        delegate?.afterTappedPostButton(accesoryView: self, commentText: textView.text)

    }
    
    @objc func handlePlaceholder() {
        customPlaceholder.isHidden = !textView.text.isEmpty
    }
    
//    override var intrinsicContentSize: CGSize { .zero }
}
