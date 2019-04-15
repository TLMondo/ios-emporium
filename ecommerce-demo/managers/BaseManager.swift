//
//  BaseManager.swift
//  DigitalVelocity
//
//  Created by Tealium User on 6/20/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation

enum BaseManagerError : Error {
    case disabled
}

class BaseManager {
    
    public static var isEnabled : Bool = false
    public static var shouldEnable : Bool = true
    
    class func allowEnable() -> Bool {
        if (shouldEnable == false) { return false }
        if (isEnabled == true) { return false }
        return true
    }
    
    class func allowDisable() -> Bool{
        if (isEnabled == false) { return false }
        return true
    }
}
