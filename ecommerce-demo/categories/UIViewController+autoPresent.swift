//
//  UIViewController+autoPresent.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/17/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Pushes navigation controller if present - otherwise modally
    func autoPresent(viewController: UIViewController) {
        guard let navC = self.navigationController else {
            self.present(viewController,
                         animated: true,
                         completion: nil)
            return
        }
        navC.pushViewController(viewController,
                                animated: true)
    }
    
    func autoDismiss() {
        guard let navC = self.navigationController else {
            self.dismiss(animated: true,
                         completion: nil)
            return
        }
        navC.popViewController(animated: true)
    }
}
