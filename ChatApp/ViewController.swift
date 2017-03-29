//
//  ViewController.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 3/25/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.uid == nil {
            firstLogIn()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))

    }

    func firstLogIn () {
        let controller  = LoginViewController()

        present(controller, animated: false, completion: nil)
        controller.loginRegisterSegmentedControl.selectedSegmentIndex = 0
        controller.handleSegmentedControlChangedSelectedIndex()
    }
    
    func handleLogOut () {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let err {
            print(err)
        }
        
        let controller  = LoginViewController()
        
        present(controller, animated: true, completion: nil)
        controller.loginRegisterSegmentedControl.selectedSegmentIndex = 0
        controller.handleSegmentedControlChangedSelectedIndex()
    }
    

}

