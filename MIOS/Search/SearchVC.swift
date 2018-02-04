//
//  SearchVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 03/02/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    //MARK: Stored properties
    
    var currentUser: User?
    var searchedUsers = [SearchedUser]()
    
    // Needs to be lazy var to access "self"
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.delegate = self
        sb.placeholder = "Enter user MIOS id"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(230, 230, 230)
        
        return sb
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.color = UIColor.mainGreen()
        
        return ai
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: Constants.CollectionViewCellIds.searchedUserCell)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        setupView()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchBar.isHidden = false
    }
    
    fileprivate func setupView() {
        
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navigationController?.navigationBar.topAnchor, left: navigationController?.navigationBar.leftAnchor, bottom: navigationController?.navigationBar.bottomAnchor, right: navigationController?.navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: -8, paddingRight: -8, width: nil, height: nil)
        
        collectionView?.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: (collectionView?.centerXAnchor)!).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: (collectionView?.centerYAnchor)!).isActive = true
    }
    
    fileprivate func fetchCurrentUser() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("SearchVC/isCurrentUserPatientOrDoctor(): Unable to recieve currentUser's uid")
        }
        
        self.enableAndActivate(bool: true)
        
        Database.fetchUserFromUserID(userID: userId) { (user) in
            if let user = user {
                self.currentUser = user
                self.enableAndActivate(bool: false)
            } else {
                fatalError("SearchVC/isCurrentUserPatientOrDoctor(): Unable to recieve User object from uid")
            }
        }
    }
    
    fileprivate func fetchSearchedUser(withId id: String) {
        
        guard let currentUser = self.currentUser else { return }
        
        if currentUser.miosId == id {
            enableAndActivate(bool: false)
            present(alert(title: "This is your id", message: "Please enter another user's id"), animated: true, completion: nil)
            return
        }
        
        if !currentUser.isDoctor {
            if id.first != "D" {
                enableAndActivate(bool: false)
                present(alert(title: "Invalid registration id", message: "Doctor id's start with 'D'"), animated: true, completion: nil)
                return
            }
        } else {
            if !(id.first == "D" || id.first == "P") {
                enableAndActivate(bool: false)
                present(alert(title: "Invalid registration id", message: "Try again please"), animated: true, completion: nil)
                return
            }
        }
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.allMIOSIds).child(id)
        databaseRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            if let dictionary = dataSnapshot.value as? [String : Any] {
                let searchedUser = SearchedUser(registrationId: id, dictionary: dictionary)
                self.searchedUsers.append(searchedUser)
                
                DispatchQueue.main.async {
                    self.enableAndActivate(bool: false)
                    self.collectionView?.reloadData()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.enableAndActivate(bool: false)
                    self.present(self.alert(title: "Invalid registration id", message: "Try again please"), animated: true, completion: nil)
                    return
                }
            }
        }) { (error) in
            print("Error: ", error)
            DispatchQueue.main.async {
                self.enableAndActivate(bool: false)
                self.present(self.alert(title: "Invalid registration id", message: "Try again please"), animated: true, completion: nil)
                return
            }
        }
    }
    
    func enableAndActivate(bool: Bool) {
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        searchBar.isHidden = bool
    }
    
    func alert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    //MARK: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        
        return CGSize(width: width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCellIds.searchedUserCell, for: indexPath) as! UserSearchCell
        
        cell.searchedUser = self.searchedUsers[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchedUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.searchBar.isHidden = true
        self.searchBar.resignFirstResponder()
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = searchedUsers[indexPath.item].userID
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    //MARK: UISearchBar delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchedUsers.removeAll()
        self.collectionView?.reloadData()
        self.enableAndActivate(bool: true)
        self.fetchSearchedUser(withId: searchBar.text!)
    }
}
