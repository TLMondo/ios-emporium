//
//  Array+AsyncTasks.swift
//  FirstImpressionSwift
//
//  Created by Tealium User on 3/2/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation


typealias AsyncTask = (_ state: AsyncState, _ completion: @escaping AsyncTaskCompletion)->()
typealias AsyncTaskCompletion = (_ state: AsyncState)->()

enum AsyncTaskResult {
    case unknown
    case ended
}

// General data struct that can be passed between async blocks
//struct AsyncState {
//    static func empty() -> AsyncState {
//        return AsyncState(appSession: nil)
//    }
//}

// Allow arrays to store and run these async blocks
extension Array {
    
    func runAsyncTasks() {
        runAsyncTask(index: 0,
                     state: AsyncState())
    }
    
    @discardableResult
    internal func runAsyncTask(index: Int,
                               state: AsyncState) -> AsyncState {
        
        if index >= self.count {
            return state
        }
        
        let nextIndex = index + 1
        
        guard let task = self[index] as? AsyncTask else {
            // Not an async task, skip
            return runAsyncTask(index: nextIndex,
                                state: state )
        }
        
        task(state) { (nextState) in
            return self.runAsyncTask(index: nextIndex,
                                     state: nextState)
        }
        
        return state
    }
    
}
