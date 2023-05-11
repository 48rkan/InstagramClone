//
//  LoginController.swift
//  Instagram
//
//  Created by Erkan Emir on 06.02.23.

import UIKit

protocol LoginControllerDelegate: AnyObject {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    
    var viewModel = LoginViewModel()
    weak var delegate: LoginControllerDelegate?
        
    private let instagramLogo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFill
        logo.image = UIImage(named: "Instagram_logo_white")
        return logo
    }()
    
    private lazy var loginTextField: UITextField = {
       let tf = CustomTextField(placeholderr: "Email")
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
       let tf = CustomTextField(placeholderr: "Password",isSecureActive: true)
        tf.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let b = UIButton()
        b.setTitle("Log in ", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .systemPurple
        b.layer.cornerRadius = b.frame.height / 2
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.isEnabled = true
        b.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let b = UIButton()
        b.setButtonConfiguration(firstText: "Don't have an account?", secondText: " Sign up")
        b.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return b
    }()
    
    private lazy var forgotPassword: UIButton = {
        let b = UIButton()
        b.setButtonConfiguration(firstText: "Forgot your password?", secondText: " Get help singing in")
        b.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return b
    }()
    
    private let defaultButton: UIButton = {
        let button = UIButton()
        button.setButtonConfiguration(firstText: "Forgot your password?", secondText: " Get help singing in")
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [loginTextField,passwordTextField,loginButton])
        s.axis = .vertical
        s.spacing = 20
        s.distribution = .fillEqually
        return s
    }()
        
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:- Actions
    
    @objc func forgotPasswordTapped() {
        let controller = ResetViewController()
        navigationController?.show(controller, sender: nil)
    }
    
    @objc private func loginTapped() {
        guard let email    = loginTextField.text    else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(email: email, password: password) { dataResult, error in
            if error != nil { return }
            self.delegate?.authenticationDidComplete()
            self.dismiss(animated: true)
        }
    }
    
    @objc private func goToRegister() {
        let vc = RegisterController()
        navigationController?.show(vc, sender: nil)
    }
    
    @objc func editingChanged(sender: UITextField) {
        if sender == loginTextField { viewModel.email = sender.text }
        else { viewModel.password = sender.text }
        updateForm()
    }
    
    func configureUI() {

        // ADD SUB LAYER ONA GORE YAZIRIQ KI , BURDA LEYER-QATMAN MENASI DASYIIR.ELE BIL OBOYU DEYISIRIK DE , QATMANINI .EKRANIN KATMANININ DEYISIRIK O BIR VIEW DEYIL AXI SUBVIEW ILE EDEK.
        configGradientLayer()
//        view.layer.addSublayer(gradient)
//        gradient.frame = view.frame
                
//        view.layer.addSublayer(gradient)
//        gradient.frame = view.frame
        
        view.addSubview(instagramLogo)
        // centerX, ve ya Center Y deyende neye nezeren center oldugunu qeyd edirik ve daha sonra burda isimiz bitir daha sonra ancor ( yeni constraints ) vermeliyik
        
        instagramLogo.centerX(inView: view)
        
        navigationController?.navigationBar.isHidden = true

        instagramLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        instagramLogo.setDimensions(height: 80, width: 120)
                
        view.addSubview(stackView)
        
        stackView.centerX(inView: view)
        stackView.anchor(top: instagramLogo.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        stackView.setHeight(180)
        
        view.addSubview(dontHaveAccountButton)
        
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 8)
        dontHaveAccountButton.setDimensions(height: 40, width: 300)
        
        view.addSubview(forgotPassword)
    
        forgotPassword.centerX(inView: view)
        forgotPassword.anchor(top: stackView.bottomAnchor,paddingTop: 4)
        forgotPassword.setDimensions(height: 40, width: 300)
    }
}

extension LoginController: UpdateFormProtocol {
    func updateForm() { loginButton.backgroundColor = viewModel.configBackgroundColor}
}
