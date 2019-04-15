//
//  LogoutLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 10/22/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

func logoutLogic(_ viewController: UIViewController) -> AsyncTask {
    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in
    
        // Clear out state data
        Persistence.purge(filename: "state",
                          success: {
            taskCompletion(AsyncState())
        }, error: { (error) in
            Log.error(error)
        })
        
        // TODO: This is less terrible
        guard let vcs = viewController.navigationController?.viewControllers else {
            return
        }
        var targetVC = vcs[0]
        for vc in vcs {
            if let tvc = vc as? LoginViewController {
                targetVC = tvc
            }
        }
        viewController.navigationController?.popToViewController(targetVC, animated: true)

    }
}
