//
//  VariablesViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 12/7/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class VariablesViewController: DemoViewController {

    @IBOutlet weak var pageDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var arrayedData : [String: Any]?
    
    @IBAction func add(_ sender: Any) {
        DispatchQueue.main.async {
            self.triggerEmptyBlock(named: "add")
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        DispatchQueue.main.async {
            self.triggerEmptyBlock(named: "clear")
        }
    }
    
    @IBAction func close(_ sender: Any) {
        triggerEmptyBlock(named: "close")
    }
    

}
