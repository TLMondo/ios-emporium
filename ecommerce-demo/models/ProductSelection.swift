//
//  ProductSelection.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

class ProductSelection : Codable {
    
    let product : Product
    var count : Int = 0
    
    init(product: Product) {
        self.product = product
    }
    
    func value() -> Int {
        guard let v = product.value else {
            return 0
        }
        return count * v
    }
    
    static func ==(lhs: ProductSelection, rhs: ProductSelection) -> Bool {
        return lhs.product == rhs.product
    }
    
}

extension ProductSelection : Hashable {
    
    var hashValue : Int {
        return self.product.hashValue
    }
}

extension Array where Element == Product {
    
    func asProductSelections() -> [ProductSelection] {
        
        var array = [ProductSelection]()
        for product in self {
            let selection = ProductSelection(product: product)
            array.append(selection)
        }
        return array
        
    }

}
