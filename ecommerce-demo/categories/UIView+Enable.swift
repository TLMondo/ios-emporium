//
//  UIButton+Enable.swift
//  ecommerce-demo
//
//  Created by Tealium User on 8/31/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

extension UIView {
    
    func enable() {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
    }
    
    func disable() {
        self.alpha = 0.5
        self.isUserInteractionEnabled = false
    }
    
    func hide(){
        self.alpha = 0.0
        self.isUserInteractionEnabled = false
    }
}
