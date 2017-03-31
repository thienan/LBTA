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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserILoggedIn()

    }

    private func checkIfUserILoggedIn() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        if uid == nil {
            firstLogIn()
        } else {
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }, withCancel: nil)
            
        }
    }
    
    func fetchUserName () {
        
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
        present(controller, animated: value, completion: nil)
        controller.loginRegisterSegmentedControl.selectedSegmentIndex = 0
        controller.handleSegmentedControlChangedSelectedIndex()
    }
}
