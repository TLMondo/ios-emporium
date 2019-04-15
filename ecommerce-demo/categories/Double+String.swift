//
//  String+Decimal.swift
//  ecommerce-demo
//
//  Created by Tealium User on 8/1/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

extension Double {
    
    func asDecimalString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let number = NSNumber.init(value: self)
        guard let result = numberFormatter.string(from: number) else {
            return "*Formatting error*"
        }
        return result
    }
}
