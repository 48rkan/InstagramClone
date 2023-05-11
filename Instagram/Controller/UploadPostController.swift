//
//  UploadPostController.swift
//  Instagram
//
//  Created by Erkan Emir on 19.03.23.
//

import UIKit

protocol UploadPostControllerDelegate: AnyObject {
    func makeShare(controller: UIViewController)
    func refreshFeedController()
}
 
class UploadPostController: UIViewController {
    
    var currentUser: User?
        
    var selectImage: UIImage? {
        didSet { selectedImageView.image = selectImage }
    }
    
    weak var delegate: UploadPostControllerDelegate?

    private let selectedImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        
        return image
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .lightGray
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        
        return textView
    }()
    
    private let customPlaceholder: UILabel = {
        let placeholder = UILabel()
        placeholder.tintColor = UIColor.lightGray
        placeholder.text = "Enter text"
        
        return placeholder
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/200"
        label.tintColor = UIColor.white
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configBarButtonItems()

        
    }

//    override var inputAccessoryView: UIView? { get { customView } }
    
    // klaviaturani avtomatik acir ki , acccesory view gorsensin . cunki klavise bitisik olur o , uzerinde olur.
    // !! canBecomeFirstResponder olmalidir !! becomeFirstResponder yox.
    
//    override var canBecomeFirstResponder: Bool { true }
    
    func configureUI() {
        navigationItem.title = "Upload"
        view.backgroundColor = .white
        
        view.addSubview(selectedImageView)
        selectedImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 paddingTop: 20,
                                 width: 200,height: 200)
        selectedImageView.centerX(inView: view)
        
        view.addSubview(textView)
        textView.anchor(top: selectedImageView.bottomAnchor,left: view.leftAnchor,
                        right: view.rightAnchor,paddingTop: 12,paddingLeft: 2,
                        paddingRight: 2,height: 160)
        
        textView.addSubview(customPlaceholder)
        customPlaceholder.anchor(top: textView.topAnchor,
                                 left: textView.leftAnchor,
                                 paddingTop: 4,paddingLeft: 6,
                                 width: 200,height: 20)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: textView.bottomAnchor,
                                   right: textView.rightAnchor,
                                   paddingBottom: 10,paddingRight: 20)
    }
    
    func configBarButtonItems() {
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clickedCancel))

        let rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(clickedShare))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func clickedCancel() { print("cancel") }
    
    @objc func clickedShare() {
        showLoader(true)
        
        guard let image = selectImage else { return }
        guard let text = textView.text else { return }
        guard let currentUser = currentUser else { return }
        
        PostService.uploadPost(image: image, text: text, user: currentUser) { error in
            if error != nil { return }
            
            self.showLoader(false)
            
            print("DEBUG: Success...")
            
            self.delegate?.makeShare(controller: self)
            self.delegate?.refreshFeedController()
            //self.dismiss(animated: true)
//            self.callBack?(self)
        }
    }
    
    @objc func textViewChanged() { customPlaceholder.isHidden = !textView.text.isEmpty }
}

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        characterCountLabel.text = "\(textView.text.count)/200"
        
        if textView.text.count > 200 { textView.deleteBackward() }
    }
}
