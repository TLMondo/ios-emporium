//
//  Persistence.swift
//  swift-qr-demo
//
//  Created by Tealium User on 7/6/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation
import KeychainAccess

enum PersistenceIOMode {
    case userDefaults
    case fileManagerAndBundle
}

enum PersistenceError: Error {
    case fileNotFound
    case couldNotDeleteFile
    case couldNotRetrieveFileAfterSaving
    case couldNotSaveToKeychain
    case couldNotConvertStringToData
    case couldNotConvertDataToString
}

typealias PersistenceErrorBlock = (_ error: Error) -> ()

@objc class Persistence: NSObject {
    
    static let serviceName = "com.tealium.emporium"
    static let keychain = Keychain(service: serviceName)
    
    // MARK: LOAD

    public class func load<T:Codable>(filename: String,
                                      type: T.Type,
                                      success: @escaping (_ object: T)->(),
                                      error: @escaping (_ error: Error)->()){
        
        do {
            guard let data = try keychain.getData(filename) else {
                error(PersistenceError.fileNotFound)
                return
            }
            let obj = try JSONDecoder().decode(type, from: data)
            success(obj)
        } catch let e {
            error(e)
        }
    }
    
    // MARK: SAVE

    public class func save<T:Codable>(_ obj: T,
                                      filename: String,
                                      success: (()->())?,
                                      error: ((_ error: Error)->())?) {
        

        
        do {
            let data = try JSONEncoder().encode(obj)
            Persistence.save(data,
                             key: filename,
                             success: success,
                             error:error)
        } catch let e {
            error?(e)
        }
        
        
    }
    
    // MARK: USING KEYCHAIN
    
    fileprivate class func load(key: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: key,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    fileprivate class func save(_ data: Data,
                    key: String,
                    success: (()->())?,
                    error: ((_ error: Error)->())?) {
        
        do {
            try keychain.set(data, key: key)
            success?()
        } catch let e {
            error?(e)
        }
    }
    
    // MARK: PURGE
    class func purge(filename:String,
                     success: @escaping ()->(),
                     error: @escaping (_ error: Error)->()){
        do {
            try keychain.remove(filename)
        } catch let e {
            error(e)
        }
    }
}
