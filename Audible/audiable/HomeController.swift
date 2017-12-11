//
//  HomeController.swift
//  audiable
//
//  Created by Ihar Tsimafeichyk on 2/20/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let imageView : UIImageView = {
        let image = UIImage(named: "home")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "We're logged in"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sing Out", style: .plain, target: self, action: #selector(handleSingOut))
        
        view.addSubview(imageView)
        
        var navBarHeigth: CGFloat
        
        if let navBar = navigationController {
            navBarHeigth = navBar.navigationBar.frame.size.height + CGFloat(20)
        } else {
            navBarHeigth = 0
        }
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeigth).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func handleSingOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)

        present(LoginViewController(), animated: true, completion: nil)
    }
    
}
