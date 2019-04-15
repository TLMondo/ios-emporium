//
//  ProductDataSource.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/26/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

class ProductSelectionDataSource : NSObject {
    
    var originalData : [ProductSelection] = [ProductSelection]()
    var filteredData : [ProductSelection]?

    func currentData() -> [ProductSelection] {
        if let d = filteredData {
            return d
        }
        return originalData
    }
    
    func numberOfSelectedProducts() -> Int {
        let count = currentData().compactMap { $0.count}.reduce(0, +)
        return count
    }
    
    func addProductCount(_ product : Product) {
        
        for selection in originalData {
            if selection.product == product {
                selection.count = selection.count + 1
            }
        }
        
    }
    
}
