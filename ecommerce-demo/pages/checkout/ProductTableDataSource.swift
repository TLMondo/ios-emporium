//
//  ProductTableViewDataSource.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/26/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import Kingfisher

class ProductTableDataSource : ProductSelectionDataSource, UITableViewDataSource {
    
    func valueOfAllProducts() -> Int {
//        let total = currentData().reduce(0.0) { $1.value() }
//        return total
        
        var total : Int = 0
        for selection in currentData(){
            total = selection.value() + total
        }
        return abs(total)
    }
    
    func addProduct(_ product : Product) {
        
        let existingProducts = currentData().filter{ $0.product == product }
        if existingProducts.count == 0 {
            // Brand new selection
            let newSelection = ProductSelection(product: product)
            newSelection.count = 1
            originalData.append(newSelection)
            return
        }
        
        guard let first = existingProducts.first else {
            return
        }
        
        first.count = first.count + 1
        
    }
    
    func numberOfProducts() -> Int {
        let count = currentData().compactMap { $0.count}.reduce(0, +)
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        
        let row = indexPath.row
        let selection = currentData()[row]
        cell.nameLabel.text = selection.product.name
        cell.unitsField.text = "\(selection.count)"
        
        if let urlString = selection.product.image_url,
            let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            cell.thumbnailImageView?.kf.setImage(with: resource)
        }
        
        if let value = selection.product.value {
            let subTotal = selection.count * abs(value)
            cell.beastcoinWithValue.valueLabel.text = "\(subTotal)"
        }
        
        
        
        let deleteButton : MGSwipeButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            [weak self](sender: MGSwipeTableCell!) -> Bool in
            self?.triggerResultBlock(named: "delete", result: indexPath)
            return true
        }
        cell.rightButtons = [deleteButton]
        
        
        return cell
    }
    
    
    
}
