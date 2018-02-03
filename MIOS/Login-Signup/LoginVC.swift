//
//  LoginVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginVC: UIViewController {
    
    //MARK: Stored properties
    
    let logoContainerView: UIView = {
        let logoView = UIView()
        logoView.backgroundColor = UIColor.mainGreen()
        
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "MIOS"
        logoLabel.textAlignment = .center
        logoLabel.textColor = .white
        logoLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        logoView.addSubview(logoLabel)
        logoLabel.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        
        return logoView
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.tintColor = UIColor.mainGreen()
        tf.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.tintColor = UIColor.mainGreen()
        tf.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        
        return tf
    }()
    
    @objc fileprivate func handleTextInputChanges() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.backgroundColor = UIColor.mainGreen().withAlphaComponent(1)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor.mainGreen().withAlphaComponent(0.3)
            loginButton.isEnabled = false
        }
        
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .white
        button.backgroundColor = UIColor.mainGreen().withAlphaComponent(0.3)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        self.enableViews(bool: false)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            
            if let _ = err {
                DispatchQueue.main.async {
                    self.present(self.alert(title: "Unable to login", message: "Verify your credentials and try again."), animated: true, completion: nil)
                    self.enableViews(bool: true)
                    return
                }
            }
            // Delete and refresh info in mainTabBar controllers
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { fatalError() }
            mainTabBarController.setupViewControllers()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let switchToSignupButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Signup", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.mainGreen()]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSwitchToSignupButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleSwitchToSignupButton() {
        let profileSelection = ProfileSelectionVC()
        navigationController?.pushViewController(profileSelection, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: view.frame.height * 0.27)
        
        setupInputFields()
        
        view.addSubview(switchToSignupButton)
        switchToSignupButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 70, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: nil, height: 150)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func alert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    func enableViews(bool: Bool) {
        emailTextField.isEnabled = bool
        passwordTextField.isEnabled = bool
        loginButton.isEnabled = bool
        switchToSignupButton.isEnabled = bool
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}
