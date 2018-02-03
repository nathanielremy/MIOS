//
//  MainTabBarController.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If no user is currently logged in, present LoginVC()
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                let navController = UINavigationController(rootViewController: loginVC)
                navController.isNavigationBarHidden = true
                self.present(navController, animated: true, completion: nil)
                
                return
            }
        } else {
            setupViewControllers()
        }
    }
    
    func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        
        // UserProfileVC
        let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserProfileVC(collectionViewLayout: layout))
        
        // ChatVC
        let chatNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "comment"), selectedImage: #imageLiteral(resourceName: "comment"), rootViewController: ChatVC(collectionViewLayout: layout))
        
        // SearchVC
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: SearchVC(collectionViewLayout: layout))
        
        // ProfileViewsVC
        let profileViewsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profileView"), selectedImage: #imageLiteral(resourceName: "profileView"), rootViewController: ProfileViewsVC(collectionViewLayout: layout))
        
        tabBar.tintColor = UIColor.mainGreen()
        
        self.viewControllers = [
            profileViewsNavController,
            searchNavController,
            chatNavController,
            userProfileNavController
        ]
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let vC = rootViewController
        let navVC = UINavigationController(rootViewController: vC)
        navVC.tabBarItem.image = unselectedImage
        navVC.tabBarItem.selectedImage = selectedImage
        
        return navVC
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
