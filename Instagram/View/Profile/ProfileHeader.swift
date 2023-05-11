//
//  ProfileHeader.swift
//  Instagram
//
//  Created by Erkan Emir on 22.02.23.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func didAction(user: User)
}

class ProfileHeader: UICollectionReusableView {
        
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            configureModel()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    private let nickLabel: UILabel = {
        let nicklabel = UILabel()
        nicklabel.font = UIFont.boldSystemFont(ofSize: 14)
        return nicklabel
    }()
    
    private lazy var editProfileButton: UIButton = {
        let editButton = UIButton()
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.addTarget(self, action: #selector(editButtonTap), for: .touchUpInside)
        
        return editButton
        
    }()
    
    private let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center

        return label
    }()
    
    private let followsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)

        return button
    }()
    
    private lazy var thirdButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been ") }
    
    func configureModel() {
        guard let viewModel = viewModel else { return }
        nickLabel.text = viewModel.fullName
        profileImage.sd_setImage(with: viewModel.profilimage)
        editProfileButton.setTitle(viewModel.buttonText, for: .normal)
        followersLabel.text = "\(viewModel.followersValue) \n follower"
        followsLabel.text = "\(viewModel.followsValue) \n follow"
        postLabel.text = "\(viewModel.postsValue) \n posts"
    }
    
    @objc func editButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.didAction(user: viewModel.user)
    }
    
    func configureUI () {
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor,
                            left: leftAnchor,
                            paddingTop: 12, paddingLeft: 12)
        profileImage.setDimensions(height: 72, width: 72)
        profileImage.layer.cornerRadius = 36
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = .red
        
        addSubview(nickLabel)
        nickLabel.anchor(top: profileImage.bottomAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 8)
        nickLabel.setDimensions(height: 24, width: 120)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: nickLabel.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 12,
                                 paddingLeft: 8,
                                 paddingRight: 8)
        editProfileButton.setHeight(40)
        
        let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followsLabel])
        
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.centerY(inView: profileImage)
        stackView.anchor(left: profileImage.rightAnchor,paddingLeft: 12)
        stackView.setDimensions(height: 120, width: 280)
        
        let buttonStack = UIStackView(arrangedSubviews: [firstButton,secondButton,thirdButton])
        addSubview(buttonStack)

        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.anchor(top: stackView.bottomAnchor,
                           left: leftAnchor,
                           bottom: bottomAnchor, right: rightAnchor)
        buttonStack.setHeight(48)
        
        let topView = UIView()
        topView.backgroundColor = .lightGray
        addSubview(topView)
        topView.anchor(top: buttonStack.topAnchor,left: leftAnchor,right: rightAnchor)
        topView.setHeight(0.4)
    }
}
