//
//  UIColor+Emporium.swift
//  ecommerce-demo
//
//  Created by Christina on 9/14/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    class func dim() -> UIColor {
        return UIColor(red: 0.0,
                       green: 0.0,
                       blue: 0.0,
                       alpha: 0.2)
    }
    
    enum Emporium {
        static let teal = UIColor(hexString: "#00A8B6")
        static let grey = UIColor(hexString: "#959BA1")
        static let blue = UIColor(hexString: "#007CC2")
        static let blueButton = UIColor(hexString: "1D8BF1")
        static let gold = UIColor(hexString: "#ffc000")
        static let mediumBlue = UIColor(hexString: "#2598D0")
        static let lightBlue = UIColor(hexString: "#68B9D9")
        static let red = UIColor(hexString: "#F04937")
        static let mediumRed = UIColor(hexString: " #E52D24")
        static let purple = UIColor(hexString: "#5B62AC")
        static let mediumPurple = UIColor(hexString: "#55499E")
        static var green = UIColor(hexString: "#4CAF50")
        static let mediumGreen = UIColor(hexString: "#62A042")
        static let lightGreen = UIColor(hexString: "#93C03D")
        static var darkPink = UIColor(hexString: "#E91E63")
        
    }
}
