//
//  UIViewController+Alerts.swift
//  ecommerce-demo
//
//  Created by Tealium User on 8/1/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(title: String,
                      message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (alert: UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
            
    }
        
    func displayAlert(title: String,
                      message: String?,
                      dismissAfterSeconds: Double) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
        let when = DispatchTime.now() + dismissAfterSeconds
        DispatchQueue.main.asyncAfter(deadline: when){
            alertController.dismiss(animated: true, completion: nil)
        }
        
    }
}
