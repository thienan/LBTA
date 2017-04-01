//
//  ViewController.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 3/25/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserILoggedIn()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"logout-icon"), style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
    }

    private func checkIfUserILoggedIn() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        if uid == nil {
            firstLogIn()
        } else {
           fetchUserName()
        }
    }
   
    func fetchUserName () {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user =  User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
                
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser (user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        if let profileImageUrl = user.profieImage {
            profileImageView.loadImagesUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        titleView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        titleView.addSubview(nameLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        navigationItem.titleView = titleView
    }
    
    @objc private func handleNewMessage () {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    private func firstLogIn () {
        presentLoginViewController(animated: false)
    }
    
    @objc private func handleLogOut () {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let err {
            print(err)
        }
        presentLoginViewController(animated: true)
    }
    private func presentLoginViewController(animated value: Bool){
        let controller  = LoginViewController()
        controller.messageViewController = self
        present(controller, animated: value, completion: nil)
        controller.loginRegisterSegmentedControl.selectedSegmentIndex = 0
        controller.handleSegmentedControlChangedSelectedIndex()
    }
}
