//
//  UITableView+Refresh.swift
//  ecommerce-demo
//
//  Created by Tealium User on 11/5/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

enum UITableViewRefreshKey {
    static var refreshControl = "refreshControl"
}

extension UITableView {
    
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(triggerRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
        
        objc_setAssociatedObject(self,
                                 &UITableViewRefreshKey.refreshControl,
                                 refreshControl,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    func endRefreshing() {
        guard let control = objc_getAssociatedObject(self,
                                                     &UITableViewRefreshKey.refreshControl) as? UIRefreshControl else {
            return
        }
        control.endRefreshing()
    }
    
    @objc func triggerRefresh() {
        NotificationCenter.default.post(name: .RequestNewContent, object: nil)
    }
    
}
