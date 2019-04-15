//
//  GenericTableViewDataSource.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 11/3/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

enum UIViewControllerTableViewKey {
    static let numberOfRows = "tableViewRows"
    static let cellForIndexPath = "tableViewCell"
    static let indexPathSelected = "indexPathSelected"
}

extension UIViewController : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        triggerResultBlock(named: UIViewControllerTableViewKey.indexPathSelected, result: indexPath)
    }
    
}

extension UIViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = triggerReturnBlock(named: UIViewControllerTableViewKey.numberOfRows, resultType: Int.self) else {
            return 0
        }
        return rows
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = triggerReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath, arg: indexPath, resultType: UITableViewCell.self) else {
            return UITableViewCell()
        }
        return cell
    }
    
    
}
