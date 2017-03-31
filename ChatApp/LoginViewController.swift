//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 3/25/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Constants and variables
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginButon: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .rgbColor(red: 80, green: 101, blue: 161, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        let font = UIFont.systemFont(ofSize: 16)
        sc.setTitleTextAttributes([NSFontAttributeName: font],
                                  for: .normal)
        sc.addTarget(self, action: #selector(handleSegmentedControlChangedSelectedIndex), for: .allEvents)
        return sc
    }()
    
    lazy var profileImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "gameofthrones_splash")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var registrationFormItems: [String] = ["Name", "Email adress", "Password"]
    var textFields = [UITextField]()
    
    lazy var nameTextField: UITextField? = { self.getRegistrationFormItem(itemName: self.registrationFormItems[0]) }()
    lazy var emailTextField: UITextField? =  { self.getRegistrationFormItem(itemName: self.registrationFormItems[1])}()
    lazy var passwordTextField: UITextField? = { self.getRegistrationFormItem(itemName: self.registrationFormItems[2])}()

    private func getRegistrationFormItem(itemName: String) -> UITextField?{
        for textField in textFields {
            if textField.placeholder == itemName { return textField }
        }
        return nil
    }
    
    var inputContainerViewHeightConstrate: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?

    // MARK: - Layout
    
    private func setupInputContainerView () {
        view.layoutIfNeeded()
        let constant = inputContainerView.frame.height / 3
        let numberOfItemsInInputContainer = 0...registrationFormItems.count - 1
        
        for number in numberOfItemsInInputContainer {
            let view: UITextField = {
                let view = UITextField()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.placeholder = registrationFormItems[number]
                if view.placeholder == "Password" {
                    view.isSecureTextEntry = true
                }
                return view
            }()
            inputContainerView.addSubview(view)
            if view.placeholder == registrationFormItems[0] {
                // Name textField workflow
                view.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
                nameTextFieldHeightConstraint = view.heightAnchor.constraint(equalToConstant: constant)
                nameTextFieldHeightConstraint?.isActive = true
            } else {
                // Name textField workflow
                view.topAnchor.constraint(equalTo: textFields.last!.bottomAnchor).isActive = true
                view.heightAnchor.constraint(equalToConstant: constant).isActive = true
            }
            view.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 10).isActive = true
            view.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
            
            textFields.append(view)
        }
        addSeparatorLine()
    }
    
    private func addSeparatorLine () {
        
        for view in textFields {
            let separatorLine : UIView = {
                let view = UIView()
                view.backgroundColor = .lightGray
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            view.addSubview(separatorLine)
            separatorLine.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -10).isActive = true
            separatorLine.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 10).isActive = true
            separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        
    }
    
    private func setupViews() {
    
        view.addSubview(inputContainerView)
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        inputContainerViewHeightConstrate = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightConstrate?.isActive = true
        setupInputContainerView()
        
        view.addSubview(loginButon)
        loginButon.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginButon.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        loginButon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButon.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        view.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rgbColor(red: 61, green: 91, blue: 151, alpha: 1)
        setupViews()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

}


extension UIColor {

    convenience init (r: CGFloat, g: CGFloat, b: CGFloat, alpha a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }

    
    static func rgbColor(red r: CGFloat, green g: CGFloat, blue b: CGFloat, alpha a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}
