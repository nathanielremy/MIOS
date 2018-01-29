//
//  ProfileSelectionVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit

class ProfileSelectionVC: UIViewController {
    
    //MARK: Stored properties
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Which one are you?"
        label.textColor = UIColor.mainGreen()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let doctorButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.mainGreen()
        button.setTitle("Doctor", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleDoctorButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleDoctorButton() {
        
        let signupVC = SignUpVC()
        signupVC.isDoctor = true
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    let patientButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.mainGreen()
        button.setTitle("Patient", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handlePatientButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func handlePatientButton() {
        let signupVC = SignUpVC()
        signupVC.isDoctor = false
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    let switchToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.mainGreen()]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSwitchToLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleSwitchToLoginButton() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        
        view.addSubview(switchToLoginButton)
        switchToLoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupView() {
        
        view.addSubview(textLabel)
        textLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 175, paddingLeft: 5, paddingBottom: 0, paddingRight: -5, width: nil, height: nil)
        
        let stackView = UIStackView(arrangedSubviews: [doctorButton, patientButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: textLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 75, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: nil, height: 150)
        
        doctorButton.layer.cornerRadius = 34
        patientButton.layer.cornerRadius = 34
    }
}
