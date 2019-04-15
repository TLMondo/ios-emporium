//
//  CrashManager.swift
//  DigitalVelocity
//
//  Created by Tealium User on 6/20/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation
import Instabug

enum CrashManagerError: Error {
    case disabled
}

class CrashManager : BaseManager {
    
    class func enable(onSuccess: NSObjectEmptyBlock,
                      onError: NSObjectGenericBlock<Error>){
        if allowEnable() == false {
            onError(CrashManagerError.disabled)
            return
        }
        isEnabled = true
        DispatchQueue.main.async {
            Instabug.start(withToken: Keys.instabug_token, invocationEvents: [.shake, .screenshot])
        }

        
        onSuccess()
    }
    
    class func disable(){
        if allowDisable() == false { return }
        isEnabled = false
        
        // Any other configuration
    }
    
}
