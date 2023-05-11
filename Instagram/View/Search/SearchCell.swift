//
//  SearchCell.swift
//  Instagram
//
//  Created by Erkan Emir on 27.02.23.
//

import UIKit
import SDWebImage

class SearchCell: UITableViewCell {
    
    var viewModel: SearchViewModel? {
        didSet {
            configureViewModel()
        }
    }
    
    private let profilImage = UIImageView()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray

        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been ") }
    
    func configureUI() {
        addSubview(profilImage)
        profilImage.centerY(inView: self)
        profilImage.anchor(left: leftAnchor,paddingLeft: 12)
        profilImage.setDimensions(height: 48, width: 48)
        profilImage.layer.cornerRadius = 48 / 2
        profilImage.clipsToBounds = true
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel,fullNameLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.alignment = .leading
        
        stack.centerY(inView: profilImage)
        stack.anchor(left: profilImage.rightAnchor,paddingLeft: 12)
        stack.setDimensions(height: 48, width: self.frame.width)
    }
    
    func configureViewModel() {
        fullNameLabel.text = viewModel?.fullName
        userNameLabel.text = viewModel?.userName
        profilImage.sd_setImage(with: viewModel?.profilImageURL )
    }
}

