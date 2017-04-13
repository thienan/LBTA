//
//  Message.swift
//  ChatApp
//
//  Created by Ihar Tsimafeichyk on 4/2/17.
//  Copyright © 2017 traban. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl : String?
    var imageWidth : NSNumber?
    var imageHeight : NSNumber?
    var videoUrl: String?
    
    func chatPartnerId () -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
