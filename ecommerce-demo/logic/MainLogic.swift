//
//  MainLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/11/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import Kingfisher

enum mainLogicError :Error {
    case couldNotFindTopViewController
    case noEmailAvailable
    case noTokenAvailable
}

func mainLogic(_ viewController: UIViewController) -> AsyncTask {
    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in

        var currentState = state
        guard var contentManager = ContentManager(state: currentState) else {
            Log.error("Could not create contentManager from state: \(currentState)")
            taskCompletion(state)
            return
        }
        
        var walletVC = WalletViewController(title: "wallet".localized(), imageName: "009-wallet-1", tag: 4)
        var catalogVC = CatalogViewController(title: "catalog".localized(), imageName: "010-price-tag-1", tag: 1)
        var cartVC = CartViewController(title: "checkout".localized(), imageName: "006-shopping-cart-black-shape", tag: 2)
        let pickupVC = PickupViewController(title: "pickup".localized(), imageName: "012-shopping-bag-1", tag: 3)
        let infoVC = InfoViewController(title: "info".localized(), imageName: "info", tag: 5)
        let accountVC = AccountViewController(title: "account".localized(), imageName: "logout", tag: 6)
        let settingsVC = SettingsViewController(title: "settings".localized(), imageName: "005-cog-wheel-silhouette", tag: 7)

        cartVC.tabBarItem.badgeColor = UIColor.Emporium.darkPink
        pickupVC.tabBarItem.badgeColor = UIColor.Emporium.green
        
        // Tabbar Controller
        let dash = DashTabBarController()
        dash.viewControllers = [walletVC, catalogVC, cartVC, pickupVC, infoVC, settingsVC, accountVC]
        viewController.autoPresent(viewController: dash)
        dash.delegate = dash
        dash.onResultBlock(named: "selectedViewController", result: UIViewController.self, block: { (viewController) in
            // A littl
            viewController.triggerResultBlock(named: "refreshProducts", result: contentManager)
            viewController.triggerResultBlock(named: "refreshTransactions", result: contentManager)
        })
        
        // Individual Page Logic setup
        // Info Page
        infoVC.onViewWillAppear { [weak infoVC] in
            infoVC?.titleLabel?.text = currentState.conference?.name
        }
        // Account Page
        accountVC.onViewWillAppear { [weak accountVC] in
            accountVC?.emailField.text = currentState.email
        }
        accountVC.onEmptyBlock(named: "logout", {
            TrackingManager.shared.trackEvent(title: "logout", data: nil)
            taskCompletion(AsyncState())
        })
        // Remaining
        walletLogic(&walletVC,
                    contentManager: &contentManager)
        
        catalogLogic(catalogVC: &catalogVC,
                     cartVC: cartVC,
                     contentManager: &contentManager)
        
        cartLogic(cartVC: &cartVC,
                  contentManager: &contentManager,
                  newSelections: {(newSelections) in
                    currentState.selections = newSelections
                    Persistence.save(currentState,
                                     filename: "state",
                                     success: {
                                        Log.debug("Updated settings: \(currentState)")
                    }, error: { (e) in
                        Log.error(e)
                    })
        })
        pickupLogic(pickupVC: pickupVC,
                    contentManager: contentManager)
        
        settingsLogic(settingsVC: settingsVC,
                      state: currentState)
        
        // Content Management
        contentManager.newProducts = { [weak dash, weak catalogVC, weak contentManager] (newProducts) in
            let svc = dash?.selectedViewController
            guard let cm = contentManager else { return }
            DispatchQueue.main.async {
                svc?.triggerResultBlock(named: "refreshProducts", result: cm)
                // A terrible bandaid
                if svc == catalogVC {
                    catalogVC?.collectionView.reloadData()
                    catalogVC?.activityIndicatorView.stopAnimating()
                }
            }
        }
        contentManager.newTransactions = { [weak dash, weak cartVC, weak pickupVC, weak contentManager] (newTransactions) in
            let svc = dash?.selectedViewController
            guard let cm = contentManager else { return }
            svc?.triggerResultBlock(named: "refreshTransactions", result: cm)
            cartVC?.triggerResultBlock(named:"refreshBadge", result: cm)
            pickupVC?.triggerResultBlock(named: "refreshBadge", result: cm)
        }
        contentManager.onError = { (error) in
            Log.error(error)
        }
        contentManager.onResultBlock(named: "deleteTransaction",
                                     result: Transaction.self,
                                     block: { [weak contentManager](transaction) in
                                        contentManager?.deleteTransactions(transactions: [transaction],
                                                                           success: {
                                                                            Log.verbose("Successfully deleted transaction: \(transaction)")
                                                                            contentManager?.updateTransactions()
                                        }, failure: { (error) in
                                            Log.error(error)
                                        })
        })
        contentManager.updateAll()
        
    }
}
