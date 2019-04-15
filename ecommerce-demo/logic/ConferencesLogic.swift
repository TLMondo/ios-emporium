//
//  ConferenceLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 10/22/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

enum ConferencesLogicError: Error {
    case tokenNotFound
}

func conferencesLogic(_ viewController: UIViewController) -> AsyncTask {
    return { (state:AsyncState, taskCompletion: @escaping AsyncTaskCompletion) in
        
        if state.conference != nil {
            // TODO:
            // Verify conference id is valid
            taskCompletion(state)
            return
        }
        
        guard let token = state.token else {
            // Should never reach here
            Log.error(ConferencesLogicError.tokenNotFound)
            return
        }
        
        var conferences = [Conference]()
        
        let conferencesVC = ViewControllerWithTableView.init(nibName: "ConferencesViewController", bundle: nil)
        conferencesVC.onViewWillAppear {
            conferencesVC.tableView.reloadData()
            conferencesVC.tableView.delegate = conferencesVC
        }
        conferencesVC.onResultBlock(named: UIViewControllerTableViewKey.indexPathSelected,
                                    result: IndexPath.self,
                                    block: { (indexPath) in
            
            let conference = conferences[indexPath.row]
            var newState = state
            newState.conference = conference
            
            if let name = conference.name {
                TrackingManager.shared.trackEvent(title: "conference_selected", data: ["conference":name])
            }
            // TODO: This always fails for some reason
            Persistence.save(newState,
                             filename: "state",
                             success: nil,
                             error: { (error) in
                                Log.error(error)
            })
            taskCompletion(newState)
                                        
        })
        
        conferencesVC.onReturnBlock(named: UIViewControllerTableViewKey.numberOfRows,
                                    resultType: Int.self,
                                    block: { () -> Int in
                return conferences.count
        })

        conferencesVC.onReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath,
                                           argType: IndexPath.self,
                                           resultType: UITableViewCell.self,
                                           block: { [weak conferencesVC](indexPath) -> UITableViewCell in
                         
                guard let cell = conferencesVC?.tableView?.dequeueReusableCell(withIdentifier: GenericKey.cellId, for: indexPath) else {
                    return UITableViewCell()
                }
        
                let conference = conferences[indexPath.row]
                cell.textLabel?.text = conference.name
        
                return cell
                                            
        })
        
        
        // Get conferences from server
        DigitalVelocityManager().getConferences(token: token,
                                                success: { (newConferences) in
                                                    
            conferences = newConferences
            DispatchQueue.main.async {
                viewController.autoPresent(viewController: conferencesVC)
            }
                                                    
            }, failure: { (error) in
                Log.error(error)
        })

    }
}
