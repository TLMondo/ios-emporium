//
//  Stringifiable+JSON.swift
//  ecommerce-demo
//
//  Created by Christina on 10/1/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

enum StringifyError: Error {
    case isNotValidJSONObject
}

struct JSONStringify {
    
    let value: Any
    
    func stringify(prettyPrinted: Bool = false) throws -> String {
        let options: JSONSerialization.WritingOptions = prettyPrinted ? .prettyPrinted : .init(rawValue: 0)
        if JSONSerialization.isValidJSONObject(self.value) {
            let data = try JSONSerialization.data(withJSONObject: self.value, options: options)
            if let string = String(data: data, encoding: .utf8) {
                return string
                
            }
        }
        throw StringifyError.isNotValidJSONObject
    }
}
protocol Stringifiable {
    func stringify(prettyPrinted: Bool) throws -> String
}

extension Stringifiable {
    func stringify(prettyPrinted: Bool = false) throws -> String {
        return try JSONStringify(value: self).stringify(prettyPrinted: prettyPrinted)
    }
}

extension Dictionary: Stringifiable {}
extension Array: Stringifiable {}
