//
//  NotificationCell.swift
//  Instagram
//
//  Created by Erkan Emir on 02.05.23.

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func cell(_ cell:NotificationCell, wantsToShowPost postID: String)
    func cell(_ cell:NotificationCell, wantsToFollow uid: String)
    func cell(_ cell:NotificationCell, wantsToUnFollow uid: String)
    func cell(_ cell:NotificationCell, wantsToShowProfile uid: String)
}

class NotificationCell: UITableViewCell {
    
    //MARK:- Properties
        
    var viewModel: NotificationCellViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedProfilePhoto)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 14)
        l.text = "venom liked your post"
        l.numberOfLines = 0
        return l
    }()
    
    private lazy var postImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedPhoto)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var followButton: UIButton = {
        let b = UIButton()
        b.setTitle("Loading", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        b.layer.borderWidth = 0.5
        b.layer.borderColor = UIColor.black.cgColor
        b.addTarget(self, action: #selector(tappedFollowButton), for: .touchUpInside)
        return b
    }()
    
    //MARK:- Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        selectionStyle = .none
    }
 
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
    
    //MARK:- Actions
    
    @objc private func tappedProfilePhoto() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToShowProfile: viewModel.items.uid)
    }
    
    @objc private func tappedFollowButton() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.items.userIsFollowed {
            delegate?.cell(self, wantsToUnFollow: viewModel.items.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.items.uid)
        }
    }
    
    @objc private func tappedPhoto() {
        guard let viewModel = viewModel  else { return }
        guard let postId = viewModel.items.postId else { return }

        delegate?.cell(self, wantsToShowPost: postId)
    }
    
    private func configureUI() {
        contentView.addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor,paddingLeft: 12)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 24
        
        contentView.addSubview(postImage)
        postImage.centerY(inView: self)
        postImage.anchor(right: rightAnchor,paddingRight: 8)
        postImage.setDimensions(height: 40, width: 44)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: contentView.rightAnchor,paddingRight: 8)
        followButton.setDimensions(height: 30, width: 80)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView,leftAnchor: profileImageView.rightAnchor,paddingLeft: 4)
        infoLabel.anchor(right: followButton.leftAnchor,paddingRight: 4 )
    }
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profilImageUrl)
        postImage.sd_setImage(with: viewModel.postImageUrl)

        infoLabel.attributedText = viewModel.descriptionAttributedText

        followButton.setTitle(viewModel.followButtonTitle, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTintColor, for: .normal)
        
        followButton.isHidden = !viewModel.shouldHide
        postImage.isHidden = viewModel.shouldHide
    }
}

