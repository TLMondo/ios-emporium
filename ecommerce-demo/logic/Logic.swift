//
//  Logic.swift
//  DigitalVelocity
//
//  Created by Jason Koo on 3/20/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import UIKit

class Logic {
    
    class func run(rootViewController: UIViewController){
        let tasks = [
            configLogic(rootViewController),
            loadLogic(rootViewController),
            loginLogic(rootViewController),
            consentsLogic(rootViewController),
            conferencesLogic(rootViewController),
            mainLogic(rootViewController),
            logoutLogic(rootViewController)
        ]
        tasks.runAsyncTasks()
    }
    
}
