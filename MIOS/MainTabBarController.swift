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
        // UserProfileVC
        let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // SearchVC
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: SearchVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        // ProfileViewsVC
        let profileViewsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profileView"), selectedImage: #imageLiteral(resourceName: "profileView"), rootViewController: ProfileViewsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = UIColor.mainGreen()
        
        self.viewControllers = [
            profileViewsNavController,
            searchNavController,
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
