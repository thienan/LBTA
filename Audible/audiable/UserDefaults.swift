//
//  UserDefaults.swift
//  audiable
//
//  Created by Ihar Tsimafeichyk on 2/20/17.
//  Copyright © 2017 traban. All rights reserved.
//

import Foundation


extension UserDefaults {

    enum UserDefaultsKeys: String {
        case isLoggedIn
    }
    
    func setIsLoggedIn (value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
}
