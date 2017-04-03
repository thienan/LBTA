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
            profileImageView.layer.cornerRadius = 30
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
            presentAlertController(title: "Login issue", message: "Name field can't be empty")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                let errorMessage = self.FIRErrorHandler(error: error!)
                self.presentAlertController(title: "Login issue", message: errorMessage)
                return
            }
            self.messageViewController?.fetchUserName()
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
                let errorMessage = self.FIRErrorHandler(error: error!)
                self.presentAlertController(title: "Registration issue", message: errorMessage)
                return
            }
            // successfully logged user
            let imageName = NSUUID().uuidString
            //let storageRef = FIRStorage.storage().reference().child("\(imageName).png")
            let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
            
            // uplaod image with compression using 10% of current quality
            if let profileImage = self.profileImageView.image, let uplodData = UIImageJPEGRepresentation(profileImage, 0.1) {
            //if let uplodData = UIImagePNGRepresentation(self.profileImageView.image!) {
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

    func FIRErrorHandler(error: Error) -> String {
        if let errCode = FIRAuthErrorCode(rawValue: error._code) {
            switch errCode {
            case .errorCodeInvalidEmail:
                //FIRAuthErrorCodeInvalidEmail - Indicates the email address is malformed.
                return "The email address is badly formatted."
            case .errorCodeEmailAlreadyInUse:
                //FIRAuthErrorCodeEmailAlreadyInUse - Indicates the email used to attempt sign up already exists.
                //Call fetchProvidersForEmail to check which sign-in mechanisms the user used,
                //and prompt the user to sign in with one of those.
                 return "The email address already in use."
            case .errorCodeWeakPassword:
                //FIRAuthErrorCodeWeakPassword - Indicates an attempt to set a password that is
                //considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
                //dictionary object will contain more detailed explanation that can be shown to the user.
                return "The password must be 6 characters long or more."
            case .errorCodeOperationNotAllowed:
                //FIRAuthErrorCodeWeakPassword - Indicates an attempt to set a password that is
                //considered too weak. The NSLocalizedFailureReasonErrorKey field in the NSError.userInfo
                //dictionary object will contain more detailed explanation that can be shown to the user.
                return "The mail and password accounts are not enabled. Enable them in the Auth section of the Firebase console."
            default:
                //FIRAuthErrorCodeOperationNotAllowed - Indicates that email and password accounts
                //are not enabled. Enable them in the Auth section of the Firebase console.
                return "Unknown error"
            }
        }
        return "Unknown error"
    }

    private func registerUserIntoDatabaseWithUID (uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("users").child(uid)
        userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            let user = User()
            user.setValuesForKeys(values)
            self.messageViewController?.setupNavBarWithUser(user: user)
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
