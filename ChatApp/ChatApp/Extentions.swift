//
//  Extentions.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 3/31/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit


extension UIColor {
    
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat, alpha a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    
    static func rgbColor(red r: CGFloat, green g: CGFloat, blue b: CGFloat, alpha a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}
var imageCached = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImagesUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        if let cachedImade = imageCached.object(forKey: urlString as NSString){
            self.image = cachedImade
            return
        }
        
        let url = URL(string: urlString)

        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let downLoadedImage = UIImage(data: data!)
                self.image = downLoadedImage
                
                imageCached.setObject(downLoadedImage!, forKey: urlString as NSString!)
            }

        }).resume()
       
    }
}
