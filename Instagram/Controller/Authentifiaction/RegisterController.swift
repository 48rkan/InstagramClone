//
//  RegisterController.swift
//  Instagram
//
//  Created by Erkan Emir on 09.02.23.

import UIKit

class RegisterController: UIViewController {
    
    var viewModel = RegisterViewModel()
    var profilImage:UIImage?
    
    private lazy var plusImageButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "plus_photo"), for: .normal)
        b.tintColor = .white
        b.addTarget(self, action: #selector(goToGallery), for: .touchUpInside)
        return b
    }()
    
    private lazy var loginTextField: UITextField = {
       let tf = CustomTextField(placeholderr: "Email")
        tf.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
       let tf = CustomTextField(placeholderr: "Password",isSecureActive: true)
        tf.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var fullNameTextField: UITextField = {
       let tf = CustomTextField(placeholderr: "Full name")
        tf.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var userNameTextField: UITextField = {
       let tf = CustomTextField(placeholderr: "User Name")
        tf.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var signUpButton: UIButton = {
        let b = UIButton()
        b.setTitle("Sign up", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemPurple
        b.layer.cornerRadius = b.frame.height / 2
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.addTarget(self, action: #selector(signUpHandler), for: .touchUpInside)
        return b
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let b = UIButton()
        b.setButtonConfiguration(firstText: "Already have an account?", secondText: "Log in")
        b.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configGradientLayer()
        configureUI()
    }
    
    //MARK:- Actions
    
    private func configureUI() {
        view.addSubview(plusImageButton)
        plusImageButton.centerX(inView: view)
        plusImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        plusImageButton.setDimensions(height: 140, width: 140)
        
        let stackView = UIStackView(arrangedSubviews: [loginTextField,passwordTextField,fullNameTextField,userNameTextField,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        stackView.centerX(inView: view)
        
        stackView.anchor(top: plusImageButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        stackView.setHeight(280)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 4)
        alreadyHaveAccountButton.setDimensions(height: 30, width: 300)
    }
    
    @objc private func goToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didChanged(textFieldim: UITextField) {
        if textFieldim == loginTextField {
            viewModel.email = textFieldim.text
        } else if textFieldim == passwordTextField {
            viewModel.password = textFieldim.text
        } else if textFieldim == fullNameTextField {
            viewModel.fullName = textFieldim.text
        } else {
            viewModel.userName = textFieldim.text
        }
        
        updateForm()
    }
    
    @objc private func goToGallery() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func signUpHandler() {
        guard let email       = loginTextField.text    else { return }
        guard let password    = passwordTextField.text else { return }
        guard let fullName    = fullNameTextField.text else { return }
        guard let userName    = userNameTextField.text else { return }
        guard let profilImage = self.profilImage       else { return }

        AuthService.registerUser(credential: AuthCredential(email: email, password: password, fullname: fullName, username: userName, profileImage: profilImage)) { error in
            print("\(error?.localizedDescription ?? "")")
            return
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension RegisterController: UpdateFormProtocol {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.configBackgroundColor
    }
}

extension RegisterController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profilImage = selectedImage
        
        plusImageButton.layer.cornerRadius = plusImageButton.frame.height / 2
        plusImageButton.clipsToBounds = true
        plusImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true)
    }
}
