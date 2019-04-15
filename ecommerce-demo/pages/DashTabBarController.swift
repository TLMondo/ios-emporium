//
//  StoreTabBarController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class DashTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DashTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.triggerResultBlock(named: "selectedViewController", result: viewController)
    }
}
