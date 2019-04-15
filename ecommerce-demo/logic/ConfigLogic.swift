//
//  ConfigLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/11/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

func configLogic(_ viewController: UIViewController) -> AsyncTask {
    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in

        let env = ProcessInfo.processInfo.environment
        
        if env["log"]?.lowercased() == "verbose" {
            Log.logLevel = .verbose
        }
        if env["log"]?.lowercased() == "warning" {
            Log.logLevel = .warning
        }
        Log.debug("Log level set to \(Log.logLevel.toString())")

        let launchArgs = ProcessInfo.processInfo.arguments
        
        if launchArgs.contains("DISABLE_FIREBASE") == false {
//            FirebaseManager.shared.start {
//                // No additional processing at this time
//            }
        }
        if launchArgs.contains("DISABLE_TRACKING") == false {
            TrackingManager.shouldEnable = true
        }
        if launchArgs.contains("DISABLE_CRASH") == false {
            CrashManager.shouldEnable = true
        }
        if launchArgs.contains("PURGE_DATA") == true {
            Persistence.purge(filename: "state", success: {
                Log.verbose("Prior state data purged")
            }, error: { (error) in
                Log.error(error)
            })
        }

        IQKeyboardManager.shared.enable = true


        taskCompletion(state)
    }
}


