//
//  SignupVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Stored properties
    var isDoctor: Bool?
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = UIColor.mainGreen()
        
        return ai
    }()
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = UIColor.mainGreen()
        button.addTarget(self, action: #selector(handlePlusPhotoButton), for: .touchUpInside)
        
        return button
    }()
    
    // Present the image picker
    @objc func handlePlusPhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Set the selected image from image picker as profile picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        // Make button perfectly round
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.mainGreen().cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        // Dismiss image picker view
        picker.dismiss(animated: true, completion: nil)
    }
    
    let registrationIdTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Orginisation's registration ID"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.tintColor = UIColor.mainGreen()
        tf.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        
        return tf
    }()
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full name"
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.tintColor = UIColor.mainGreen()
        tf.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        
        return tf
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
    
    let passwordOneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.tintColor = UIColor.mainGreen()
        tf.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTwoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Re-enter password"
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.tintColor = UIColor.mainGreen()
        tf.addTarget(self, action: #selector(handleTextInputChanges), for: .editingChanged)
        
        return tf
    }()
    
    @objc fileprivate func handleTextInputChanges() {
        let isFormValid = registrationIdTextField.text?.count ?? 0 > 0 && fullNameTextField.text?.count ?? 0 > 0 && emailTextField.text?.count ?? 0 > 0 && passwordOneTextField.text?.count ?? 0 > 5 && passwordTwoTextField.text?.count ?? 0 > 5
        
        if isFormValid {
            signupButton.backgroundColor = UIColor.mainGreen().withAlphaComponent(1)
            signupButton.isEnabled = true
        } else {
            signupButton.backgroundColor = UIColor.mainGreen().withAlphaComponent(0.3)
            signupButton.isEnabled = false
        }
    }
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tintColor = .white
        button.backgroundColor = UIColor.mainGreen().withAlphaComponent(0.3)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(verifyImage), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func verifyImage() {
        
        enableAndActivate(true)
        
        if !verifyInputFields() {
            enableAndActivate(false)
            return
        }
        
        if plusPhotoButton.imageView?.image == #imageLiteral(resourceName: "plus_photo") {
            
            let alert = UIAlertController(title: "No profile image", message: "Are you sure that you do not want to set your profile image now?", preferredStyle: .alert)
            let imSureAction = UIAlertAction(title: "I'm sure", style: .default, handler: { (action) in
                self.verifyPassword()
            })
            let setImageAction = UIAlertAction(title: "Set image", style: .default, handler: { (action) in
                self.enableAndActivate(false)
                self.handlePlusPhotoButton()
                return
            })
            
            alert.addAction(imSureAction)
            alert.addAction(setImageAction)
            
            present(alert, animated: true, completion: nil)
        } else {
            self.verifyPassword()
        }
    }
    
    fileprivate func verifyPassword() {
        
        // Verify that input fields are filled out ?
        guard let registrationId = registrationIdTextField.text, registrationId.count > 0 else { enableAndActivate(false); return }
        guard let email = emailTextField.text, email.count > 0 else { enableAndActivate(false); return }
        guard let fullName = fullNameTextField.text, fullName.count > 0 else { enableAndActivate(false); return }
        guard let passwordOne = passwordOneTextField.text, passwordOne.count > 0 else { enableAndActivate(false); return }
        guard let passwordTwo = passwordTwoTextField.text, passwordTwo.count > 0 else { enableAndActivate(false); return }
        
        if passwordOne != passwordTwo {
            present(alert(title: "Try again", message: "Both passwords must match and be atleast 6 characters long"), animated: true, completion: nil)
            enableAndActivate(false)
            return
        }
        
        verifyRegistrationId(registrationId: registrationId, email: email, password: passwordOne, fullName: fullName)
    }
    
    // Make sure that the registrationId used is valid
    func verifyRegistrationId(registrationId: String, email: String, password: String, fullName: String) {
        
        guard let isDoctor = self.isDoctor else {
            print("This VC (SignupVC should not be on screen)"); navigationController?.popViewController(animated: true); return
        }
        
        let databaseRef = Database.database().reference()
        
        if isDoctor {
            
            let doctorDatabaseRef = databaseRef.child(Constants.FirebaseDatabase.doctorRegistrationIdRef)
            doctorDatabaseRef.child(registrationId).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                
                guard let value = dataSnapshot.value as? [String : Any] else {
                    DispatchQueue.main.async {
                        self.enableAndActivate(false)
                        let errorAlert = self.alert(title: "Invalid Registration Id", message: "Please enter a valid regisrationID or contact MIOS to create one.")
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                    return
                }
                
                if self.validateDoctorCount(for: value) {
                    
                    self.handleSignup(registrationId: registrationId, email: email, password: password, fullName: fullName)
                    
                } else {
                    DispatchQueue.main.async {
                        self.enableAndActivate(false)
                        let errorAlert = self.alert(title: "Invalid Registration Id", message: "This registration id cannot signup anymore doctors.")
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                    return
                }
             }, withCancel: { (error) in
                DispatchQueue.main.async {
                    self.enableAndActivate(false)
                    let errorAlert = self.alert(title: "Invalid Registration Id", message: "Please enter a valid regisrationID or contact MIOS to create one.")
                    self.present(errorAlert, animated: true, completion: nil)
                }
                
                print("NO Match found for doctorRegistrationId: ", error)
                return
            })
        } else {
            
            let patientDatabaseRef = databaseRef.child(Constants.FirebaseDatabase.patientRegistrationIdRef)
            patientDatabaseRef.child(registrationId).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                
                guard let _ = dataSnapshot.value as? [String : Any] else {
                    DispatchQueue.main.async {
                        self.enableAndActivate(false)
                        let errorAlert = self.alert(title: "Invalid Registration Id", message: "Please enter a valid regisrationID or contact MIOS to create one.")
                        self.present(errorAlert, animated: true, completion: nil)
                    }
                    return
                }

                self.handleSignup(registrationId: registrationId, email: email, password: password, fullName: fullName)

            }, withCancel: { (error) in
                DispatchQueue.main.async {
                    self.enableAndActivate(false)
                    let errorAlert = self.alert(title: "Invalid Registration Id", message: "Try again or go to a local medical authority to recieve a valid registration id.")
                    self.present(errorAlert, animated: true, completion: nil)
                }

                print("NO Match found for patientRegistrationId: ", error)
                return
            })
        }
    }
    
    func handleSignup(registrationId: String, email: String, password: String, fullName: String) {
        
        if !verifyInputFields() {
            enableAndActivate(false)
            return
        }
        
        // Create user in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (User, err) in
            
            if let error = err { print("Error creating user: ", error)
                DispatchQueue.main.async {
                    self.enableAndActivate(false)
                }
                return
            }
            
            guard let user = User else {
                DispatchQueue.main.async {
                    self.enableAndActivate(false)
                }
                return
            }
            
            guard let image = self.plusPhotoButton.imageView?.image, let imageData = UIImageJPEGRepresentation(image, 0.3) else {
                DispatchQueue.main.async {
                    self.enableAndActivate(false)
                }
                return
            }
            
            // create a random file name to add profile image to Firebase storage
            let randomFile = UUID().uuidString
            let storageRef = Storage.storage().reference().child(Constants.FirebaseStorage.profileImages).child(randomFile)
            storageRef.putData(imageData, metadata: nil, completion: { (metaData, err) in
                
                if let error = err { print("Error uploading profile image to Storage: ", error)
                    DispatchQueue.main.async {
                        self.enableAndActivate(false)
                    }
                    return
                }
                
                guard let profileImageURL = metaData?.downloadURL()?.absoluteString else { print("ProfileImage could not return a URL from storage")
                    DispatchQueue.main.async {
                        self.enableAndActivate(false)
                    }
                    return
                }
                
                print("Succesfully uploaded profile image to storage: ", profileImageURL)
                
                var userValues = [Constants.FirebaseDatabase.fullName : fullName, Constants.FirebaseDatabase.email : email, Constants.FirebaseDatabase.profileImageURLString : profileImageURL] as [String : Any]
                
                guard let doctor = self.isDoctor else { fatalError("This VC (SignupVC should not be on screen)") }
                
                if doctor {
                    userValues[Constants.FirebaseDatabase.isDoctor] = 1
                } else {
                    userValues[Constants.FirebaseDatabase.isDoctor] = 0
                }
                
                let values = [user.uid : userValues]
                
                let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.usersRef)
                databaseRef.updateChildValues(values, withCompletionBlock: { (err, databaseReference) in
                    
                    if let error = err {
                        print("Failed to save user info into database", error)
                        DispatchQueue.main.async {
                            self.enableAndActivate(false)
                        }
                        return
                    }
                    
                    if let isDoctor = self.isDoctor {
                        if isDoctor {
                            self.updateDoctorCount(forRegistrationId: registrationId)
                        } else {
                            let sexAndBirthdateVC = SexAndBirthdateVC()
                            self.navigationController?.pushViewController(sexAndBirthdateVC, animated: true)
                        }
                    } else {
                        return
                    }
                })
            })
        }
    }
    
    fileprivate func validateDoctorCount(for value: [String : Any]) -> Bool {
        
        guard let signedUp = value[Constants.FirebaseDatabase.signedUpDoctors] as? [String : Any] else {
            return true
        }
        guard let limit = value[Constants.FirebaseDatabase.doctorRegistrationLimit] as? Int else {
            return false
        }
        
        if signedUp.count < limit {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func updateDoctorCount(forRegistrationId registrationID: String) {
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let values = [userId : 1]
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.doctorRegistrationIdRef).child(registrationID).child(Constants.FirebaseDatabase.signedUpDoctors)
        databaseRef.updateChildValues(values) { (err, _) in
            if let error = err {
                fatalError("Failed to update signup doctors: \(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.enableAndActivate(false)
            print("No VC yet for doctor signup")
        }
     }
    
    fileprivate func enableAndActivate(_ bool: Bool) {
        
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        plusPhotoButton.isEnabled = !bool
        registrationIdTextField.isEnabled = !bool
        fullNameTextField.isEnabled = !bool
        emailTextField.isEnabled = !bool
        passwordOneTextField.isEnabled = !bool
        passwordTwoTextField.isEnabled = !bool
        signupButton.isEnabled = !bool
        navigationItem.backBarButtonItem?.isEnabled = !bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Signup"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        guard let _ = self.isDoctor else { print("This VC (SignupVC should not be on screen)"); navigationController?.popViewController(animated: true); return }
        
        let stackView = UIStackView(arrangedSubviews: [registrationIdTextField, fullNameTextField, emailTextField, passwordOneTextField, passwordTwoTextField, signupButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: -40, width: nil, height: 250)
        
        registrationIdTextField.delegate = self
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordOneTextField.delegate = self
        passwordTwoTextField.delegate = self
    }
    
    fileprivate func verifyInputFields() -> Bool {
        // Verify that input fields are filled out ?
        guard let registrationId = registrationIdTextField.text, registrationId.count > 0 else { return false }
        guard let email = emailTextField.text, email.count > 0 else { return false }
        guard let fullName = fullNameTextField.text, fullName.count > 0 else { return false }
        guard let passwordOne = passwordOneTextField.text, passwordOne.count > 0 else { return false }
        guard let passwordTwo = passwordTwoTextField.text, passwordTwo.count > 0 else { return false }
        
        return true
    }
    
    func alert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
}

// UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}
