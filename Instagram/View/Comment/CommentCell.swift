//
//  CommentCell.swift
//  Instagram
//
//  Created by Erkan Emir on 11.04.23.

import UIKit
import SDWebImage
 
protocol CommentCellDelegate: AnyObject {
    func wantsToShowProfile(cell:CommentCell)
}

class CommentCell: UICollectionViewCell {
    
    var viewModel: CommentCellViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: CommentCellDelegate?
    
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let commentLabel =  UILabel()
    
    //MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }

    func configureUI() {
        contentView.addSubview(profileImage)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfilePhoto))
        profileImage.addGestureRecognizer(gesture)
        profileImage.isUserInteractionEnabled = true
        profileImage.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 4)
        profileImage.setDimensions(height: 48, width: 48)
        profileImage.layer.cornerRadius = 24
    
        contentView.addSubview(commentLabel)
        commentLabel.centerY(inView: profileImage,leftAnchor: profileImage.rightAnchor,paddingLeft: 8)
        commentLabel.anchor(bottom: bottomAnchor,right: rightAnchor,paddingBottom: 2,paddingRight: 8)
    }
    
    @objc func tappedProfilePhoto() {
        delegate?.wantsToShowProfile(cell: self)
    }
    
    func configure() {
        profileImage.sd_setImage(with: viewModel?.imageURL)
        commentLabel.attributedText = viewModel?.configureLabel()
        commentLabel.numberOfLines  = 0
    }
}
