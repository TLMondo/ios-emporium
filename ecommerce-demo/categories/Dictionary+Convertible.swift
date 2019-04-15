//
//  Dictionary+Convertible.swift
//  ecommerce-demo
//
//  Created by Tealium User on 12/14/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    func asStringString() -> [String:String] {
        var result = [String:String]()
        for key in self.keys {
            if let v = self[key] as? String {
                result[key] = v
            }
        }
        return result
    }
    
}

extension Dictionary where Key == String, Value == String {
    
    func asStringAny() -> [String:Any] {
        var result = [String:Any]()
        for key in self.keys {
            let v = self[key] as Any
            result[key] = v
        }
        return result
    }
}
