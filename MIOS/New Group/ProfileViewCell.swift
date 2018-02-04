//
//  ProfileViewCell.swift
//  MIOS
//
//  Created by Nathaniel Remy on 04/02/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewCell: UICollectionViewCell {
    
    //MARK: Stored properties
    var profileView: ProfileView? {
        didSet {
            guard let profView = profileView else { return }
            
            profileImageView.loadImage(from: profView.user.profileImageURLString)
            
            let attributedText = NSMutableAttributedString(string: profView.user.miosId, attributes: [.font : UIFont.boldSystemFont(ofSize: 14), .foregroundColor : UIColor.black])
            attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 8)]))
            
            if profView.user.isDoctor {
                attributedText.append(NSAttributedString(string: "Dr. ", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
            }
            
            attributedText.append(NSAttributedString(string: profView.user.fullName, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor : UIColor.black]))
            attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 8)]))
            attributedText.append(NSAttributedString(string: profView.date.timeAgoDisplay(), attributes: [.font : UIFont.systemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
            
            informationLabel.attributedText = attributedText
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
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
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.layer.borderColor = UIColor.mainGreen().cgColor
        profileImageView.layer.borderWidth = 2
        
        addSubview(informationLabel)
        informationLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 15, paddingBottom: -8, paddingRight: -8, width: nil, height: nil)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.mainGreen()
        
        addSubview(seperatorView)
        seperatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 1)
    }   
}
