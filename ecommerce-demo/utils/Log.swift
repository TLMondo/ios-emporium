//
//  Log.swift
//  Template
//
//  Created by Jason Koo on 9/25/17.
//  Copyright © 2017 jalakoo. All rights reserved.
//

import Foundation

enum LogLevelString {
    static let none = "none"
    static let error = "error"
    static let warning = "warning"
    static let verbose = "verbose"
}

enum LogLevel : Int {
    case none = 0
    case error
    case warning
    case verbose
    
    func toString() -> String {
        switch self {
        case .none:
            return LogLevelString.none
        case .error:
            return LogLevelString.error
        case .warning:
            return LogLevelString.warning
        case .verbose:
            return LogLevelString.verbose
        }
    }
    
    static func fromString(_ string: String?) -> LogLevel {
        if string == LogLevelString.error { return .error }
        if string == LogLevelString.warning { return .warning }
        if string == LogLevelString.verbose { return .verbose }
        return .none
    }
}

class Log {
    
    static var logLevel: LogLevel = .none
    
    @discardableResult
    class func debug(_ message: String,
                     filename: String = #file,
                     function: String = #function,
                     line: Int = #line) -> String? {

        return Log.log(message,
                       level: .verbose,
                       filename: filename,
                       function: function,
                       line: line)
    }
    
    // More sensible naming convention than debug
    @discardableResult
    class func verbose(_ message: String,
                     filename: String = #file,
                     function: String = #function,
                     line: Int = #line) -> String? {
        
        return Log.log(message,
                       level: .verbose,
                       filename: filename,
                       function: function,
                       line: line)
    }
    
    @discardableResult
    class func error(_ message: String,
                     filename: String = #file,
                     function: String = #function,
                     line: Int = #line) -> String? {

        return Log.log(message,
                       level: .error,
                       filename: filename,
                       function: function,
                       line: line)
    }

    @discardableResult
    class func error(_ error: Error,
                     filename: String = #file,
                     function: String = #function,
                     line: Int = #line) -> String? {
        
        let message = "\(error)"
        return Log.log(message,
                       level: .error,
                       filename: filename,
                       function: function,
                       line: line)
    }
    
    @discardableResult
    class func warning(_ message: String,
                     filename: String = #file,
                     function: String = #function,
                     line: Int = #line) -> String? {
        
        return Log.log(message,
                       level: .warning,
                       filename: filename,
                       function: function,
                       line: line)
    }
    
    @discardableResult
    class func log(_ message: String,
                   level: LogLevel,
                   filename: String = #file,
                   function: String = #function,
                   line: Int = #line) -> String? {
    
        if level.rawValue > logLevel.rawValue {
            return nil
        }
    
        let pattern = "[^\\/]+$"
        let match = Regex.matches(forPattern: pattern,
        in: filename)[0]
        let mode = level.toString()
        let result = "\n\(match): \(function): line \(line): [\(mode)]: \(message)"
        print(result)
        return result
    }
}

