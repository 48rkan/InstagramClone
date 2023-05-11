//
//  ResetViewController.swift
//  Instagram
//
//  Created by Erkan Emir on 10.05.23.

import UIKit

class ResetViewController: UIViewController {
    
    var viewModel = ResetViewModel()
    
    //MARK: - Properties
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Instagram_logo_white")
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholderr: "Email")
        tf.addTarget(self, action: #selector(handleTextFields), for: .editingChanged)
        return tf
    }()
    
    private lazy var resetButton: UIButton = {
        let b = UIButton()
        b.setTitle("Reset Password", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.isEnabled = false
        b.addTarget(self, action: #selector(tappedResetButton), for: .touchUpInside)
        
        return b
    }()
    
    private lazy var stackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [emailTextField,resetButton])
        s.axis = .vertical
        s.spacing = 20
        s.distribution = .fillEqually
        return s
    }()
    
    private lazy var backButton: UIButton = {
        let b = UIButton()
        b.tintColor = .white
        b.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        b.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        return b
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helper
    
    func configureUI() {
        let gradient = CAGradientLayer()
        view.layer.addSublayer(gradient)

        gradient.colors = [UIColor.systemBlue.cgColor,UIColor.systemPurple.cgColor]
        gradient.locations = [0,1]
        gradient.frame = view.frame

        view.addSubview(iconImage)
        iconImage.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 80, width: 120)
        
        view.addSubview(stackView)
        stackView.centerX(inView: view, topAnchor: iconImage.bottomAnchor, paddingTop: 32)
        stackView.anchor(left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 32,paddingRight: 32)
        stackView.setHeight(120)
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 12,paddingLeft: 8)
        backButton.setDimensions(height: 20, width: 20)
    }
    
    //MARK: - Actions
    
    @objc func tappedBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextFields(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        
        updateForm()
    }
    
    @objc func tappedResetButton() {
        print("button tapped")
        navigationController?.popViewController(animated: true)
    }
    
    func updateForm() {
        resetButton.backgroundColor = viewModel.configBackgroundColor
        resetButton.isEnabled = viewModel.formIsValid
     
    }
}
