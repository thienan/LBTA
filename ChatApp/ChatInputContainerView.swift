//
//  ChatInputContainerView.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 4/13/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class ChatInputContainerView : UIView, UITextFieldDelegate {
    
    var chatLogController: ChatLogController? {
        didSet {
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
            
            let tapGesture = UITapGestureRecognizer.init(target: chatLogController, action: #selector(ChatLogController.handleSendImage))
            sendImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgbColor(red: 220, green: 220, blue: 220, alpha: 1)
        return view
    }()
    
    lazy var textInputField: UITextField = {
        let view = UITextField()
        view.placeholder = "Type text message here.."
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sent"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sendImageView: UIImageView = {
        let image = UIImage(named: "upload_image_icon")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true

        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(self.separatorLine)
        self.separatorLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        self.separatorLine.bottomAnchor.constraint(equalTo: topAnchor).isActive = true
        self.separatorLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        self.separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(self.sendButton)
        self.sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        self.sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        self.sendButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(self.sendImageView)
        self.sendImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        self.sendImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.sendImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.sendImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(self.textInputField)
        self.textInputField.leftAnchor.constraint(equalTo: self.sendImageView.rightAnchor, constant: 8).isActive = true
        self.textInputField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.textInputField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        self.textInputField.rightAnchor.constraint(equalTo: self.sendButton.leftAnchor).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        textInputField.resignFirstResponder()
        return true
    }

}
