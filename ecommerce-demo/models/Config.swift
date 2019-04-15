//
//  config.swift
//  swift-qr-demo
//
//  Created by Tealium User on 7/24/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

struct Config : Codable {
    
    let account : String?
    let profile : String?
    let env : String?
    let datasourceId : String?
    let traceId : String?
    var enableTealium: Bool?
    var customData : [String:String]?
    
    init() {
        self.account = nil
        self.profile = nil
        self.env = "dev"
        self.datasourceId = nil
        self.traceId = nil
        self.customData = [String:String]()
    }
    
    init(account: String?,
         profile: String?,
         environment : String?,
         datasourceId: String?,
         traceId : String?,
         enableTealium: Bool? = false,
         customData: [String:String]?) {
        self.account = account
        self.profile = profile
        self.env = environment
        self.datasourceId = datasourceId
        self.traceId = traceId
        self.customData = customData
        if let et = enableTealium {
            self.enableTealium = et
        }
    }
    
    init(config: Config) {
        self.account = config.account
        self.profile = config.profile
        self.env = config.env
        self.datasourceId = config.datasourceId
        self.traceId = config.traceId
        self.customData = config.customData
        if let et = config.enableTealium {
            self.enableTealium = et
        }
    }
    
    // Simple validation check
    func isValid() -> Bool {
        if account?.isEmpty == true { return false }
        if profile?.isEmpty == true { return false }
        return true
    }
    
    static func ==(lhs: Config, rhs: Config) -> Bool {
        if lhs.account != rhs.account { return false }
        if lhs.profile != rhs.profile { return false }
        if lhs.env != rhs.env { return false }
        if lhs.datasourceId != rhs.datasourceId { return false }
        if lhs.traceId != rhs.traceId { return false }
        if lhs.customData != rhs.customData { return false }
        if lhs.enableTealium != rhs.enableTealium { return false }
        return true
    }
}
