//
//  LoginLogic.swift
//  ecommerce-demo
//
//  Created by Christina on 9/20/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

enum LoginLogicStrings {
    static var login = "login"
}

func loginLogic(_ viewController: UIViewController) -> AsyncTask {

    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in
        
        // Previously logged in
        if state.token?.isEmpty == false {
            // TODO: Check that token is still valid
            let email = state.email
            TrackingManager.shared.trackEvent(title: "login", data: ["email":email])
            taskCompletion(state)
            return
        }
        
        // User needs to login
        var updatedState = state
        let loginViewController = LoginViewController()
        loginViewController.view.accessibilityIdentifier = LoginLogicStrings.login.localized()
//        loginViewController.view.backgroundColor = UIColor(patternImage: UIImage(named: "teal_dots.jpg")!)
        viewController.autoPresent(viewController: loginViewController)
        
        loginViewController.onEmptyBlock(named: LoginLogicStrings.login, { [weak loginViewController] in
            
            guard let email = loginViewController?.emailField?.text?.lowercased() else {
                Log.error("Missing email")
                return
            }
            guard let password = loginViewController?.passwordField?.text else {
                Log.error("Missing password")
                return
            }
            
            loginViewController?.loginButton?.showLoading()
            let dvManager = DigitalVelocityManager()
            dvManager.getToken(email: email,
                               conferenceId: "MDt5LRJv",
                                password: password,
                                success: { [weak loginViewController] (token) in
                                    
                                // Save token
                                updatedState.token = token
                                updatedState.email = email
                                    
                                Persistence.save(updatedState,
                                                 filename: "state",
                                                 success: nil,
                                                 error: { (e) in
                                    Log.error(e)
                                })
                                    
                                TrackingManager.shared.trackEvent(title: "login", data: ["email":email])
                                    
                                // Proceed regardless if token persisted
                                taskCompletion(updatedState)
                                    
                                // Clear out login field data
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    loginViewController?.loginButton?.hideLoading()
                                    loginViewController?.emailField?.text = nil
                                    loginViewController?.passwordField?.text = nil
                                    loginViewController?.emailField?.becomeFirstResponder()
                                    loginViewController?.triggerStateChange()
                                }

                                
            }, failure: { (error) in
                Log.error(error)

                DispatchQueue.main.async { [weak loginViewController] in
                    loginViewController?.loginButton?.hideLoading()
                    loginViewController?.displayAlert(title: "Invalid email & password combo", message: nil)
                }
                
            })
            
        })
    }
}
