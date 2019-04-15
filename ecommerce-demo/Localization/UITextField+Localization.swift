//
//  UITextField+Localization.swift
//  DigitalVelocity
//
//  Created by Tealium User on 7/10/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable var localizedKey: String {
        get {
            return self.text!
        }
        set(value) {
            self.text = value.localized()
        }
    }
    
}
