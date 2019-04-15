//
//  TrackingManager.swift
//  DigitalVelocity
//
//  Created by Christina on 5/11/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation
import TealiumSwift

enum TrackingManagerError : Error {
    case alreadyEnabled
    case deinitialized
    case disabled
    case missingConfigData
}

class TrackingManager : BaseManager {
    
    static let shared = TrackingManager()
    var _tealium: Tealium?
    var _traceId: String?
    var _customData: [String:Any] = [String:Any]()
    
    func enable(config: Config,
                success: @escaping NSObjectEmptyBlock,
                error: NSObjectGenericBlock<Error>?) {
        if TrackingManager.shouldEnable == false {
            TrackingManager.shared.stop()
            TrackingManager.isEnabled = false
            error?(TrackingManagerError.disabled)
            return
        }
        if let c = config.customData {
            _customData = c
        }
        guard let a = config.account,
            let p = config.profile,
            let e = config.env else {
            error?(TrackingManagerError.missingConfigData)
            return
        }

        let tConfig = TealiumConfig(account: a,
                                   profile: p,
                                   environment: e,
                                   datasource: config.datasourceId,
                                   optionalData: config.customData)
        
        tConfig.setConsentLoggingEnabled(true)
        tConfig.setInitialUserConsentStatus(.consented)
        tConfig.setLogLevel(logLevel: .errors)
        tConfig.setModulesList(TealiumModulesList(isWhitelist: false, moduleNames: ["autotracking"]))
        _tealium = Tealium(config: tConfig,
                           enableCompletion: { [weak self] (responses) in
                            success()
            guard let s = self else {
                error?(TrackingManagerError.deinitialized)
                return
            }
            TrackingManager.isEnabled = true
            s._tealium?.volatileData()?.add(data: s._customData)
            success()
        })
    }
    
    func startTrace(_ tid: String) {
        if tid == _traceId {
            return
        }
        _traceId = tid
        _tealium?.volatileData()?.add(data: ["tealium_trace_id" : tid])
    }
    
    func stopTrace() {
        if nil == _traceId {
            return
        }
        _traceId = nil
        _tealium?.trackView(title: "killTrace", data: ["event":"kill_visitor_session", "cp.trace_id":"XXXXX"], completion: nil)
    }
    
    func stop() {
        _tealium?.disable()
        _tealium = nil
    }
    
    func getCustomData() -> [String:Any] {
        return _customData
    }
    
    func addCustom(key: String, value: Any) {
        _customData[key] = value
        _tealium?.volatileData()?.add(data: [key:value])
    }
    
    func removeCustomKey(_ keys: [String]) {
        guard let t = _tealium else {
            for key in keys {
                self._customData.removeValue(forKey: key)
            }
            return
        }
        t.volatileData()?.deleteData(forKeys: keys)
    }
    
    func removeAllCustomKeys(){
        let keys = Array(_customData.keys)
        _tealium?.volatileData()?.deleteData(forKeys: keys)
        _customData.removeAll()
    }
    
    func trackAppearance(_ viewController: UIViewController) {
        if TrackingManager.isEnabled == false {
            return
        }
        if let id = viewController.view.accessibilityIdentifier {
            _tealium?.trackView(title: id, data: nil, completion: nil)
            return
        }
        if let title = viewController.title {
            _tealium?.trackView(title: title, data: nil, completion: nil)
        }
    }
    
    func trackView(title: String, data: [String:Any]?) {
        if TrackingManager.isEnabled == false {
            return
        }
        _tealium?.trackView(title: title, data: data, completion: nil)
    }
    
    func trackEvent(title: String, data: [String:Any]?) {
        if TrackingManager.isEnabled == false {
            return
        }
        _tealium?.track(title: title, data: data, completion: { (success, response, error) in
            if let e = error {
                Log.error(e)
                return
            }
            Log.debug("Response: \(String(describing: response))")
        })
    }
    
    func traceAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Tealium Trace", message: "See staff for a demo of UDH Trace", preferredStyle: .alert)
        var executeAction: UIAlertAction
        
        if let _ = TrackingManager.shared._traceId {
            executeAction = UIAlertAction(title: "Stop", style: .default) { (_) in
                TrackingManager.shared.stopTrace()
            }
        } else {
            executeAction = UIAlertAction(title: "Start", style: .default) { (_) in
                guard let textFields = alertController.textFields,
                    textFields.count > 0 else {
                        // Could not find textfield
                        return
                }
                
                let field = textFields[0]
                guard let text = field.text else {
                    Log.error("No trace id entered.")
                    return
                }
                // store your data
                TrackingManager.shared.startTrace(text)
            }

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            if let tid = TrackingManager.shared._traceId {
                textField.text = tid
            } else {
                textField.text = nil
            }
        }
        
        alertController.addAction(executeAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
}
