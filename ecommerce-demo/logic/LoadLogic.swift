//
//  LoadLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/11/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

func loadLogic(_ viewController: UIViewController) -> AsyncTask {
    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in

        Persistence.load(filename: "state",
                         type: AsyncState.self,
                         success: { (loadedState) in

            Log.verbose("Loaded State: \(loadedState)")
                            
            if let tid = loadedState.config.traceId {
                TrackingManager.shared.startTrace(tid)
            }
            TrackingManager.shouldEnable = loadedState.config.enableTealium ?? false
            if TrackingManager.shouldEnable == true {
                TrackingManager.shared.enable(config: loadedState.config,
                                              success: {
                    Log.verbose("Tracking manager enabled")
                }, error: { (e) in
                    Log.error(e)
                })
            }
            taskCompletion(loadedState)

        }, error: { (e) in
            Log.error(e)
            taskCompletion(state)
        })
        
    }
}
