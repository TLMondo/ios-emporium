//
//  GenericViewControllerWithTableView.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 11/3/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

enum GenericKey {
    static let cellId = "cellIdentifier"
}

class ViewControllerWithTableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: GenericKey.cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }


}
