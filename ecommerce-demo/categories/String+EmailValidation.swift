//
//  String+EmailValidation.swift
//  ecommerce-demo
//
//  Created by Christina on 9/19/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}
