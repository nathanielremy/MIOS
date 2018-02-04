//
//  ProfileView.swift
//  MIOS
//
//  Created by Nathaniel Remy on 04/02/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation

struct ProfileView {
    
    let user: User
    let date: Date
    
    init(user: User, dictionary: [String : Any]) {
        
        self.user = user
        let secondsFrom1970 = dictionary[Constants.FirebaseDatabase.date] as? Double ?? 0
        self.date = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
