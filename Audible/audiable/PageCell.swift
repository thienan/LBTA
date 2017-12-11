//
//  PageCell.swift
//  audiable
//
//  Created by Ihar Tsimafeichyk on 2/19/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var pageContent : PageModel? {
        didSet {
            
            guard let page = pageContent else {
                return
            }
            
            var imageName = page.image
            
            if UIDevice.current.orientation.isLandscape {
                imageName += "_landscape"
            }
            
            
            imageView.image = UIImage(named: imageName)
            
            let color = UIColor(white: 0.2, alpha: 1)
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
            
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: color]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedText.string.characters.count
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText

        }
    }
    
    let lineSeparator : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return line
    }()
    
    let imageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        // avoid issue with incorrect showing images during swiping
        image.clipsToBounds = true
        return image
    }()
    
    let textView : UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isUserInteractionEnabled = false
        // text 24 p from the top
        text.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return  text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
        imageView.image = UIImage(named: "page1")
        
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparator)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        lineSeparator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lineSeparator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineSeparator.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0, constant: 1).isActive = true
        lineSeparator.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
