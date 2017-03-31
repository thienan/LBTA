//
//  LoginViewController+handler.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 3/31/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Actons handlers
    
    func handleSegmentedControlChangedSelectedIndex() {
        loginButon.setTitle(loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex), for: .normal)
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            inputContainerViewHeightConstrate?.constant = 150
            nameTextFieldHeightConstraint?.constant = 50
            nameTextField?.isHidden = false
            
        } else {
            inputContainerViewHeightConstrate?.constant = 100
            nameTextFieldHeightConstraint?.constant = 0
            nameTextField?.isHidden = true
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutSubviews()
        })
    }
    
    func handleTapGesture() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: {})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedInageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedInageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedInageFromPicker = originalImage
        }
        
        if let selectedImage = selectedInageFromPicker {
            profileImageView.image = selectedImage
            profileImageView.layer.cornerRadius = 50
            profileImageView.layer.masksToBounds = true
        
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    
    func handleRegisterLogin() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            register()
        } else {
            login()
        }
        
    }
    
    private func login() {
        guard let email = emailTextField?.text, let password = passwordTextField?.text else {
            return
        }
        if email.isEmpty {
            presentAlertController(title: "Registration issue", message: "Name field can't be empty")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
            if err != nil {
                print(err!)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    
    private func register () {
        guard let email = emailTextField?.text, let password = passwordTextField?.text, let name = nameTextField?.text else {
            return
        }
        if name.isEmpty {
            presentAlertController(title: "Registration issue", message: "Name field can't be empty")
            return
        } else if email.isEmpty {
            presentAlertController(title: "Registration issue", message: "Email field can't be empty")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                var errorMessage: String = "Unknown error"
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        //FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
                        errorMessage = "The email address is badly formatted."
                    case .errorCodeEmailAlreadyInUse:
                        //FIRAuthErrorCodeEmailAlreadyInUse - Indicates the email used to attempt sign up already exists.
                        //Call fetchProvidersForEmail to check which sign-in mechanisms the user used,
                        //and prompt the user to sign in with one of those.
                        errorMessage = "The email address already in use."
                    case .errorCodeWeakPassword:
                        //FIRAuthErrorCodeWeakPassword - Indicates an attempt to set a password that is
                        //considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
                        //dictionary object will contain more detailed explanation that can be shown to the user.
                        errorMessage = "The password must be 6 characters long or more."
                    default:
                        //FIRAuthErrorCodeEmailAlreadyInUse - Indicates the email used to attempt sign up
                        //already exists. Call fetchProvidersForEmail to check which sign-in mechanisms the user
                        //used, and prompt the user to sign in with one of those.
                        //FIRAuthErrorCodeOperationNotAllowed - Indicates that email and password accounts
                        //are not enabled. Enable them in the Auth section of the Firebase console.
                        errorMessage = "The mail and password accounts are not enabled. Enable them in the Auth section of the Firebase console."
                    }
                }
                self.presentAlertController(title: "Registration issue", message: errorMessage)
                return
            }
            // successfully logged user
            
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
            
            if let uplodData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.put(uplodData, metadata: nil, completion: { (metadata, err) in
                    if err != nil {
                        print(err!)
                    } else {
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            let values: [String : AnyObject] = ["name": name as AnyObject , "email": email as AnyObject, "profieImage": profileImageUrl as AnyObject]
                            self.registerUserIntoDatabaseWithUID(uid: (user?.uid)!, values: values)
                        }
                    }
                })
            }
            
            

            
        })
    }
    
    private func registerUserIntoDatabaseWithUID (uid: String, values: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference(fromURL: "https://chatapp-540d5.firebaseio.com/")
        let userRef = ref.child("users").child(uid)
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            print("Saved user successfully into Firebase db")
            self.dismiss(animated: true, completion: nil)
        })
    
    }
    
    private func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
