//
//  Array+Sorting.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 12/26/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    func asSortedTupleArray() -> [(String, String)] {
        let keys = self.keys.sorted()
        var result = [(String,String)]()
        for key in keys {
            guard let value = self[key] as? String else {
                continue
            }
            result.append((key, value))
        }
        return result
    }
    
}

extension Dictionary where Key == String, Value == String {
    
    func asSortedTupleArray() -> [(String, String)] {
        let keys = self.keys.sorted()
        var result = [(String,String)]()
        for key in keys {
            guard let value = self[key] else {
                continue
            }
            result.append((key, value))
        }
        return result
    }
    
}
