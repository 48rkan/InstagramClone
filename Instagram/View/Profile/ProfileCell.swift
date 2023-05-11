//
//  ProfileCell.swift
//  Instagram
//
//  Created by Erkan Emir on 22.02.23.

import UIKit

class ProfileCell: UICollectionViewCell {
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    private let profilImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill

        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been") }
    
    func configureUI() {
        addSubview(profilImage)
        profilImage.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 0,paddingLeft: 0,paddingBottom: 0,paddingRight: 0)
    }
    
    func configure() {
        profilImage.sd_setImage(with: viewModel?.postImageUrl)
    }
}

