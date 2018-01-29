//
//  UserProfileHeaderCell.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit

class UserProfileHeaderCell: UICollectionViewCell {
    
    //MARK: Stored properties
    
    var user: User? {
        didSet {
            
            guard let user = self.user else { return }
            
            profileImageView.loadImage(from: user.profileImageURLString)
            
            if user.isDoctor {
                let attributedText = NSMutableAttributedString(string: user.fullName, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.black])
                attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 8)]))
                attributedText.append(NSAttributedString(string: "Doctor", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
                
                informationLabel.attributedText = attributedText
            } else {
                
                let attributedText = NSMutableAttributedString(string: user.fullName, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.black])
                attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 8)]))
                attributedText.append(NSAttributedString(string: "Patient", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
                attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 8)]))
                
                if let birthdate = user.birthdate, let age = birthdate.age {
                    attributedText.append(NSAttributedString(string: "\(age), ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
                } else {
                    attributedText.append(NSAttributedString(string: "No age,", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
                }
                
                attributedText.append(NSAttributedString(string: user.sex, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
                
                informationLabel.attributedText = attributedText
            }
            
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let contactInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Contact Info", for: .normal)
        button.setTitleColor(UIColor.mainGreen(), for: .normal)
        button.layer.borderColor = UIColor.mainGreen().cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.mainGreen().cgColor
        profileImageView.layer.borderWidth = 2
        
        let bottomSeperatorView = UIView()
        bottomSeperatorView.backgroundColor = UIColor.mainGreen()
        addSubview(bottomSeperatorView)
        bottomSeperatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 1)
        
        addSubview(contactInfoButton)
        contactInfoButton.anchor(top: nil, left: nil, bottom: bottomSeperatorView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -6, paddingRight: 0, width: 160, height: 30)
        contactInfoButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let topSeperatorView = UIView()
        topSeperatorView.backgroundColor = UIColor.mainGreen()
        addSubview(topSeperatorView)
        topSeperatorView.anchor(top: nil, left: leftAnchor, bottom: contactInfoButton.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -6, paddingRight: 0, width: nil, height: 1)
        
        addSubview(informationLabel)
        informationLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: topSeperatorView.topAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 5, paddingBottom: -8, paddingRight: -5, width: nil, height: nil)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
