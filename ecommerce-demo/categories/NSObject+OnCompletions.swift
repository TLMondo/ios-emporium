//
//  NSObject+OnCompletions.swift
//
//  Created by Jason Koo on 1/7/18.
//  Copyright © 2018 jalakoo. All rights reserved.
//

// USAGE:  Static enum must be created in subclass


import Foundation

typealias NSObjectEmptyBlock = () -> ()
typealias NSObjectGenericBlock<T> = (_ result: T) -> ()
typealias NSObjectGenericReturnBlock<T> = ()->T
typealias NSObjectGenericReturnBlockWithArg<A, T> = (_ a: A)->T


enum NSObjectKey {
    static var onError = "onError"
    static var emptyBlocks = "emptyBlocks"
    static var resultBlocks = "resultBlocks"
    static var returnBlocks = "returnBlocks"
    static var returnBlocksWithArg = "returnBlocksWithArg"

}

extension NSObject {
    
    func onEmptyBlock(named: String, _ block: @escaping NSObjectEmptyBlock) {
        var blocks = objc_getAssociatedObject(self,
                                              &NSObjectKey.emptyBlocks) as? [String: NSObjectEmptyBlock]
        if blocks == nil {
            blocks = [String:NSObjectEmptyBlock]()
        }
        
        blocks?[named] = block
        
        objc_setAssociatedObject(self,
                                 &NSObjectKey.emptyBlocks,
                                 blocks,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    func triggerEmptyBlock(named: String) {
        let blocksRaw = objc_getAssociatedObject(self,
                                                 &NSObjectKey.emptyBlocks)
        guard let blocks = blocksRaw as? [String: NSObjectEmptyBlock] else {
            return
        }
        guard let targetBlock = blocks[named] else {
            return
        }
        targetBlock()
    }
    
    func onResultBlock<T>(named: String, result: T.Type, block: @escaping NSObjectGenericBlock<T>) {
        var blocks = objc_getAssociatedObject(self,
                                              &NSObjectKey.resultBlocks) as? [String: NSObjectGenericBlock<T>]
        if blocks == nil {
            blocks = [String:NSObjectGenericBlock<T>]()
        }
        
        blocks?[named] = block
        
        objc_setAssociatedObject(self,
                                 &NSObjectKey.resultBlocks,
                                 blocks,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    func triggerResultBlock<T>(named: String, result: T) {
        let blocksRaw = objc_getAssociatedObject(self,
                                                 &NSObjectKey.resultBlocks)
        guard let blocks = blocksRaw as? [String: NSObjectGenericBlock<T>] else {
            return
        }
        guard let targetBlock = blocks[named] else {
            return
        }
        targetBlock(result)
    }
    
    func onReturnBlock<T>(named: String,
                          resultType: T.Type,
                          block: @escaping NSObjectGenericReturnBlock<T>){
        var blocks = objc_getAssociatedObject(self,
                                              &NSObjectKey.returnBlocks) as? [String: NSObjectGenericReturnBlock<T>]
        if blocks == nil {
            blocks = [String:NSObjectGenericReturnBlock<T>]()
        }
        
        blocks?[named] = block
        
        objc_setAssociatedObject(self,
                                 &NSObjectKey.returnBlocks,
                                 blocks,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func triggerReturnBlock<T>(named: String,
                               resultType: T.Type) -> T?{
        
        let blocksRaw = objc_getAssociatedObject(self,
                                                 &NSObjectKey.returnBlocks)
        guard let blocks = blocksRaw as? [String: NSObjectGenericReturnBlock<T>] else {
            return nil
        }
        guard let targetBlock = blocks[named] else {
            return nil
        }
        return targetBlock()
    }
    
    func onReturnBlockWithArg<A,T>(named: String,
                                   argType: A.Type,
                                   resultType: T.Type,
                                   block: @escaping NSObjectGenericReturnBlockWithArg<A,T>){
        var blocks = objc_getAssociatedObject(self,
                                              &NSObjectKey.returnBlocksWithArg) as? [String: NSObjectGenericReturnBlockWithArg<A, T>]
        if blocks == nil {
            blocks = [String:NSObjectGenericReturnBlockWithArg<A,T>]()
        }
        
        blocks?[named] = block
        
        objc_setAssociatedObject(self,
                                 &NSObjectKey.returnBlocksWithArg,
                                 blocks,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func triggerReturnBlockWithArg<A,T>(named: String,
                                        arg: A,
                                        resultType: T.Type) -> T?{
        
        let blocksRaw = objc_getAssociatedObject(self,
                                                 &NSObjectKey.returnBlocksWithArg)
        guard let blocks = blocksRaw as? [String: NSObjectGenericReturnBlockWithArg<A, T>] else {
            return nil
        }
        guard let targetBlock = blocks[named] else {
            return nil
        }
        return targetBlock(arg)
    }
    
}
