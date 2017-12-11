//
//  LoginCell.swift
//  audiable
//
//  Created by Ihar Tsimafeichyk on 2/19/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "logo"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let emailTextField: LeftPaddingTextField = {
        let textfield = LeftPaddingTextField()
        textfield.placeholder = "Enter email"
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.keyboardType = .emailAddress
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let passwordTextField: LeftPaddingTextField = {
        let textfield = LeftPaddingTextField()
        textfield.placeholder = "Enter password"
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var loginButton: UIButton = {
        let button =  UIButton(type: .system)
        button.backgroundColor = .orange
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginAction), for: .touchUpInside)
        return button
    }()

    // break retain cycle
    weak var delegate: LogginControllerDelegate?
    
    func handleLoginAction() {
        delegate?.finishLoggingIn()
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        setupView ()
    }
    
    func setupView () {
    
        addSubview(imageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -160).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 32).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 32).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16).isActive = true
        loginButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        loginButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 32).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class LeftPaddingTextField : UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10 , height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10 , height: bounds.height)

    }
    
}

