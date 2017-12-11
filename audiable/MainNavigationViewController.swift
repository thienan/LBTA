//
//  MainNavigationViewController.swift
//  audiable
//
//  Created by Ihar Tsimafeichyk on 2/20/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if isLoggedIn() {
            let homeController = HomeController()
            viewControllers = [homeController]
        } else {
        
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
            
        }
    }

    fileprivate func isLoggedIn () -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    func showLoginController () {
        let loginController = LoginViewController()
        present(loginController, animated: false, completion: {
            
        })

    }

}

