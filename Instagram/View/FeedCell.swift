//
//  FeedCell.swift
//  Instagram
//
//  Created by Erkan Emir on 29.01.23.
//

import UIKit
import SDWebImage

protocol FeedCellDelegate: AnyObject {
    func wantsToShowComment(cell: FeedCell, post: Post)
    func wantsToLikePost(cell: FeedCell, post: inout Post)
    func clickedLikesLabel(cell: FeedCell , post: Post)
    func cell(_ cell: FeedCell , wantsToShowProfileWith uid: String)
}

class FeedCell: UICollectionViewCell {
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: FeedCellDelegate?
    
    private lazy var profilImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showProfileScene)))
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private lazy var userNameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(showProfileScene), for: .touchUpInside)
        
        return button
    }()
    
    private let postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.addTarget(self, action: #selector(clickedLikedButton), for: .touchUpInside)
        
        return likeButton
    }()
    
    private lazy var commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.setImage(UIImage(named: "comment"), for: .normal)
        commentButton.addTarget(self, action: #selector(clickedCommentButton), for: .touchUpInside)
        
        return commentButton
    }()
    
    private lazy var sharedButton: UIButton = {
        let sharedButton = UIButton()
        sharedButton.setImage(UIImage(named: "send2"), for: .normal)
        
        return sharedButton
    }()
        
    lazy var likeLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "1 likes"
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        lbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likesLabelTapped)))
        lbl.isUserInteractionEnabled = true
        return lbl
    }()
    
    private var descriptionLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "Any text entered here"
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        return lbl
    }()
    
    private var captionLabel: UILabel = {
       let lbl = UILabel()
        lbl.text = "2 days ago"
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 12)
        
        return lbl
    }()
    
    //MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
    
    //MARK:- Actions
    
    @objc func likesLabelTapped() {
        guard let viewModel = viewModel else { return }

        delegate?.clickedLikesLabel(cell: self, post: viewModel.item)
    }
    
    func configureUI() {
        backgroundColor = .white
        
        addSubview(profilImage)
        profilImage.anchor(top: safeAreaLayoutGuide.topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 8)
        profilImage.setDimensions(height: 40, width: 40)
        profilImage.layer.cornerRadius = 40 / 2
        profilImage.clipsToBounds = true
        
        addSubview(userNameButton)
        userNameButton.anchor(top: topAnchor, left: profilImage.rightAnchor,paddingTop: 10,paddingLeft: 0)
        userNameButton.centerY(inView: profilImage)
        userNameButton.setDimensions(height: 40, width: 80)
        
        addSubview(postImage)
        postImage.anchor(top: profilImage.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 10,paddingLeft: 8,paddingRight: 8)
        postImage.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true
        postImage.heightAnchor.constraint(equalTo: widthAnchor).isActive = true

        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sharedButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        addSubview(stackView)
        stackView.anchor(top: postImage.bottomAnchor,left: leftAnchor, paddingTop: 4,paddingLeft: 8)
        stackView.setDimensions(height: 30, width: 80)
        
        addSubview(likeLabel)
        likeLabel.anchor(top: stackView.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: likeLabel.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: descriptionLabel.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 4)
    }
    
    //MARK:- Actions
    
    @objc func showProfileScene() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfileWith: viewModel.item.ownerUid)
    }
    
    @objc func clickedCommentButton() {
        guard let viewModel = viewModel else { return }
        delegate?.wantsToShowComment(cell: self, post: viewModel.item)
    }
    
    @objc func clickedLikedButton() {
        guard let viewModel = viewModel else { return }

        delegate?.wantsToLikePost(cell: self, post: &viewModel.item)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }

        descriptionLabel.text = viewModel.description
        likeLabel.text = viewModel.likes
        postImage.sd_setImage(with: viewModel.imageUrl)
        userNameButton.setTitle(viewModel.ownerUserName, for: .normal)
        profilImage.sd_setImage(with: viewModel.ownerImageUrl)
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    }
}

