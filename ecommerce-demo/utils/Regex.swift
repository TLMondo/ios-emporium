//
//  Regex.swift
//  Template
//
//  Created by Jason Koo on 9/25/17.
//  Copyright © 2017 jalakoo. All rights reserved.
//

import Foundation

class Regex {

    class func matches(forPattern regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            Log.error(error)
            return []
        }
    }
    
}
