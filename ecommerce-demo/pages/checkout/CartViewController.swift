//
//  CartViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import IBAnimatable

class CartViewController: DemoViewController {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var checkoutButton: AnimatableButton!
    @IBOutlet weak var noContentLabel: UILabel!
    @IBOutlet weak var subtotalCoinWithValue: CoinWithValueXibView!
    @IBOutlet weak var totalCoinWithValue: CoinWithValueXibView!
//    weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
//        tableView?.backgroundView = activityIndicatorView
//        self.activityIndicatorView = activityIndicatorView
//        activityIndicatorView.startAnimating()
//        activityIndicatorView.hidesWhenStopped = true
        tableView?.addRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkout(_ sender: Any) {
        triggerEmptyBlock(named: "checkout")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
}

