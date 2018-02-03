//
//  UserSearchCell.swift
//  MIOS
//
//  Created by Nathaniel Remy on 03/02/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit

class UserSearchCell: UICollectionViewCell {
    
    //MARK: Stored properties
    var searchedUser: SearchedUser? {
        didSet {
            guard let user = searchedUser else { return }
            
            let attributedText = NSMutableAttributedString(string: user.registrationId, attributes: [.font : UIFont.boldSystemFont(ofSize: 16), .foregroundColor : UIColor.black])
            attributedText.append(NSAttributedString(string: "\n\n", attributes: [.font : UIFont.systemFont(ofSize: 8)]))
            attributedText.append(NSAttributedString(string: user.fullName, attributes: [.font : UIFont.systemFont(ofSize: 12), .foregroundColor : UIColor.lightGray]))
         
            self.infoLabel.attributedText = attributedText
        }
    }
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(infoLabel)
        infoLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.mainGreen()
        
        addSubview(bottomView)
        bottomView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
