//
//  SettingsLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 11/1/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

func settingsLogic(settingsVC: SettingsViewController,
                   state: AsyncState) {
    
    var currentState = state
    
    settingsVC.onViewWillAppear {
        settingsVC.pageDescription.text = "settings_description".localized()
        settingsVC.enableSwitch.isOn = TrackingManager.isEnabled
        settingsVC.accountField.text = currentState.config.account
        settingsVC.profileField.text = currentState.config.profile
        settingsVC.envField.text = currentState.config.env
        settingsVC.datasourceField.text = currentState.config.datasourceId
        settingsVC.traceField.text = currentState.config.traceId
        settingsVC.triggerEmptyBlock(named: "updateUI")
    }
    
    settingsVC.onEmptyBlock(named: "save", { [weak settingsVC] in
        
        guard let svc = settingsVC else {
            return
        }
        
        // Deselect any active fields
        DispatchQueue.main.async {
            svc.accountField.becomeFirstResponder()
            svc.accountField.resignFirstResponder()
        }
        
        // New Config
        let convertedCustomData = TrackingManager.shared._customData.asStringString()
        let newConfig = Config(account: svc.accountField.text,
                               profile: svc.profileField.text,
                               environment: svc.envField.text,
                               datasourceId: svc.datasourceField.text,
                               traceId: svc.traceField.text,
                               enableTealium: svc.enableSwitch.isOn,
                               customData: convertedCustomData)
        
        // Skip saving if no change in config
        if newConfig == currentState.config {
            return
        }
        
        // Persist new config
        currentState.config = newConfig
        currentState.save(success: nil,
                          failure: { (e) in
            Log.error(e)
        })
        
        // Update Tealium
        if TrackingManager.isEnabled == true {
            TrackingManager.shared.stop()
        }
        
        TrackingManager.shouldEnable = svc.enableSwitch.isOn
        TrackingManager.shared.enable(config: newConfig,
                                      success: { [weak settingsVC] in
            DispatchQueue.main.async {
                // Trace
                if let tid = settingsVC?.traceField.text,
                    tid != "" {
                    TrackingManager.shared.startTrace(tid)
                } else {
                    TrackingManager.shared.stopTrace()
                }
            }
        }, error: { (e) in
            Log.error(e)
        })
        
        svc.displayAlert(title: "Settings updated", message: nil, dismissAfterSeconds: 3.0)
    })
    settingsVC.onEmptyBlock(named: "openCustomData") { [weak settingsVC] in
        let vVC = VariablesViewController(title: "customdata".localized(), imageName: "", tag: 10)
        vVC.onViewDidLoad { [weak vVC] in
            vVC?.pageDescription.text = "customdata_description".localized()
            vVC?.tableView.register(MGSwipeTableCell.self, forCellReuseIdentifier: "cellIdentifier")
            vVC?.tableView.delegate = vVC
            vVC?.tableView.dataSource = vVC
            vVC?.tableView.reloadData()
        }
        vVC.onReturnBlock(named: UIViewControllerTableViewKey.numberOfRows,
                           resultType: Int.self,
                           block: {
            let sortedData = TrackingManager.shared.getCustomData().asSortedTupleArray()
            return sortedData.count
        })
        vVC.onReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath,
                                  argType: IndexPath.self,
                                  resultType: UITableViewCell.self) { [weak vVC] (indexPath) -> UITableViewCell in
            guard let cell = vVC?.tableView?.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? MGSwipeTableCell else {
                return MGSwipeTableCell()
            }
            let sortedData = TrackingManager.shared.getCustomData().asSortedTupleArray()
            let keyValue = sortedData[indexPath.row]
            cell.textLabel?.text = "\(keyValue.0) : \(keyValue.1)"
            let deleteButton : MGSwipeButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
                (sender: MGSwipeTableCell!) -> Bool in
                TrackingManager.shared.removeCustomKey([keyValue.0])
                vVC?.tableView.reloadData()
                return true
            }
            cell.rightButtons = [deleteButton]
            return cell
        }
        vVC.onResultBlock(named: UIViewControllerTableViewKey.indexPathSelected,
                          result: IndexPath.self,
                          block: { (indexPath) in
            // Bring up alert to edit
        })
        vVC.onEmptyBlock(named: "add") { [weak vVC] in
            guard let vc = vVC else {
                return
            }
            let alertController = UIAlertController(title: "New Custom Data", message: nil, preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Key"
            }
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Value"
            }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (alert: UIAlertAction) in
                guard let key = alertController.textFields?[0].text else {
                    return
                }
                guard let value = alertController.textFields?[1].text else {
                    return
                }
                TrackingManager.shared.addCustom(key: key, value: value)
                let convertedCustomData = TrackingManager.shared._customData.asStringString()
                currentState.config.customData = convertedCustomData
                currentState.save(success: {
                    Log.verbose("State saved")
                }, failure: { (e) in
                    Log.error(e)
                })
                
                vVC?.tableView.reloadData()
                alertController.dismiss(animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            DispatchQueue.main.async {
                vc.present(alertController, animated: true, completion: nil)
                vc.tableView.reloadData()
            }
        }
        vVC.onEmptyBlock(named: "clear") { [weak vVC] in
            TrackingManager.shared.removeAllCustomKeys()
            let convertedCustomData = TrackingManager.shared._customData.asStringString()
            currentState.config.customData = convertedCustomData
            currentState.save(success: {
                Log.verbose("State saved")
            }, failure: { (e) in
                Log.error(e)
            })
            vVC?.tableView.reloadData()
        }
        vVC.onEmptyBlock(named: "close") { [weak vVC] in
            vVC?.dismiss(animated: true, completion: nil)
        }
        settingsVC?.autoPresent(viewController: vVC)

    }
    settingsVC.onEmptyBlock(named: "updateUI", { [weak settingsVC] in
        
        guard let svc = settingsVC else {
            return
        }
        
        svc.traceField.placeholderColor = .gray
        svc.datasourceField.placeholderColor = .gray

        if svc.accountField.text?.isEmpty == true {
            svc.accountField.placeholderColor = .red
        } else {
            svc.accountField.placeholderColor = .green
        }
        
        if svc.profileField.text?.isEmpty == true {
            svc.profileField.placeholderColor = .red
        } else {
            svc.profileField.placeholderColor = .green
        }
        if svc.envField.text?.isEmpty == true {
            svc.envField.placeholderColor = .red
        } else {
            svc.envField.placeholderColor = .green
        }
        
        let newConfig = Config(account: svc.accountField.text,
                               profile: svc.profileField.text,
                               environment: svc.envField.text,
                               datasourceId: svc.datasourceField.text,
                               traceId: svc.traceField.text,
                               enableTealium: svc.enableSwitch.isOn,
                               customData: currentState.config.customData)
        
        if newConfig == currentState.config {
            svc.triggerEmptyBlock(named: "saveComplete")
        } else {
            svc.triggerEmptyBlock(named: "configChanged")
        }
        
        
    })
    
    settingsVC.onEmptyBlock(named: "configChanged") { [weak settingsVC] in
        guard let svc = settingsVC else {
            return
        }
        svc.saveButton.setTitle("Save", for: .normal)
        svc.saveButton.backgroundColor = .blue
        svc.saveButton.isUserInteractionEnabled = true
        svc.saveButton.alpha = 0.4
        
    }
    
    settingsVC.onEmptyBlock(named: "saveComplete") { [weak settingsVC] in
        guard let svc = settingsVC else {
            return
        }
        svc.saveButton.setTitle("Saved", for: .normal)
        svc.saveButton.backgroundColor = .gray
        svc.saveButton.isUserInteractionEnabled = false
        svc.saveButton.alpha = 1.0
    }
    
}
