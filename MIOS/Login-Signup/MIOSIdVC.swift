//
//  MIOSIdVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class MIOSIdVC: UIViewController {
    
    //MARK: Stored properties
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = UIColor.mainGreen()
        
        return ai
    }()
    
    let mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Your MIOS identification"
        label.textColor = UIColor.mainGreen()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        var attributedText = NSMutableAttributedString(string: "THIS IDENTIFICATION IS CASE SENSITIVE", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .foregroundColor : UIColor.black.withAlphaComponent(0.7)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 5)]))
        attributedText.append(NSAttributedString(string: "This is your identification and this will be the main way to identify yourself and/or get identified by doctors within this system.", attributes: [.font : UIFont.systemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let miosIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .center
        
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("DONE", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = UIColor.mainGreen()
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        
        return button
    }()
    
    //Save user's mios identification to database
    @objc func handleDoneButton() {
        
        enableAndActivate(true)
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let miosId = miosIdLabel.text, miosId.count > 0 else { return }
        
        let values = [Constants.FirebaseDatabase.miosId : miosId]
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.usersRef).child(currentUserId)
        databaseRef.updateChildValues(values) { (err, dataBaseReference) in
            
            if let error = err {
                print("Could not save miosId to database", error); return
            }
            
            self.enableAndActivate(false)

            // Delete and refresh info in mainTabBar controllers
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { fatalError() }
            mainTabBarController.setupViewControllers()

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Get the MIOS Identification for the user
    fileprivate func fetchMIOSId() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            fatalError("MIOSIDVC/fetchMIOSId(): No userID returned from Firebase")
        }
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.usersRef).child(currentUserId)
        databaseRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let userDictionary = dataSnapshot.value as? [String : Any], let isDoctor = userDictionary[Constants.FirebaseDatabase.isDoctor] as? Int, let fullName = userDictionary[Constants.FirebaseDatabase.fullName] as? String else {
                print("MIOSIDVC/fetchMIOSId()/: Could not cast dataSnapshot.value to [String:Any]")
                return
            }
            
            var miosIdText: String
            
            if isDoctor == 1 {
                miosIdText = "D" + currentUserId.prefix(10)
            } else {
                miosIdText = "P" + currentUserId.prefix(10)
            }
            
            DispatchQueue.main.async {
                self.miosIdLabel.text = miosIdText
            }
            
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Noooo userID...."); return
            }
            
            self.addRegistrationId(registrationId: miosIdText, fullName: fullName, userId: userId)
            
        }) { (error) in
            print("Error: ", error)
        }
    }
    
    // Add MIOSID to database
    fileprivate func addRegistrationId(registrationId: String, fullName: String, userId: String) {
        
        let values = [registrationId : [Constants.FirebaseDatabase.userId : userId, Constants.FirebaseDatabase.fullName : fullName]]
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.allRegistrationIds)
        databaseRef.updateChildValues(values) { (err, _) in
            
            if let error = err {
                fatalError("SignupVC/addRegistrationId: Error saving registrationId to database: \(error)")
            }
            
            self.enableAndActivate(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "MIOS Identification"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        setupView()
        enableAndActivate(true)
        fetchMIOSId()
    }
    
    fileprivate func setupView() {
        
        view.addSubview(mainTextLabel)
        mainTextLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: mainTextLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        view.addSubview(miosIdLabel)
        miosIdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        miosIdLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(doneButton)
        doneButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -20, paddingRight: 0, width: 200, height: 50)
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func enableAndActivate(_ bool: Bool) {
        
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        doneButton.isEnabled = !bool
    }
    
    
    
    
    
    
    
    
    
    
}
