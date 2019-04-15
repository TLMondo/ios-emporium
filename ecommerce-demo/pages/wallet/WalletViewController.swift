//
//  WalletViewController.swift
//  ecommerce-demo
//
//  Created by Christina on 9/13/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import Kingfisher

enum WalletViewControllerError : Error {
    case noMatchingProductFound
}

class WalletViewController: DemoViewController {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var beastcoinWithValue: CoinWithValueXibView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ProductWithBeastcoinTableViewCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "cellIdentifier")
        tableView?.addRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
