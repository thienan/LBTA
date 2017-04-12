//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 4/3/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "TEXT TEXT TEXt"
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    static let blueColor = UIColor.rgbColor(red: 0, green: 137, blue: 249, alpha: 1)
    static let grayColor = UIColor.rgbColor(red: 240, green: 240, blue: 240, alpha: 1)
    
    let bubleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let messageImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleRightAnchor : NSLayoutConstraint?
    var bubbleLeftAnchor : NSLayoutConstraint?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(bubleView)

        bubbleLeftAnchor = bubleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleRightAnchor = bubleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)

        bubleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubleView.heightAnchor).isActive = true
        
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: bubleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
