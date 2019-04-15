//
//  ConsentsLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/11/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

func consentsLogic(_ viewController: UIViewController) -> AsyncTask {
    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in

        Log.verbose("ConsentsLogic")

        
        // TODO - present consents that enable / disable features on privacy preferences
        
        CrashManager.enable(onSuccess: {
            Log.debug("Crash Manager enabled")
        }, onError: { (e) in
            Log.error(e)
        })
        
        DispatchQueue.main.async {
            taskCompletion(state)
        }
    }
}
