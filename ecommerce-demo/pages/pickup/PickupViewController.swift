//
//  PickupViewController.swift
//  ecommerce-demo
//
//  Created by Christina on 9/13/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import Kingfisher

class PickupViewController: DemoViewController {

    @IBOutlet weak var tableView: UITableView?
    var transactions : [Transaction]?
    var products : [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProductWithStatusTableViewCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "cellIdentifier")
        tableView?.addRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
