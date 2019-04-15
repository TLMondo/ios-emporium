//
//  UIViewController+OnViewCompletions.swift
//  Template
//
//  Created by Jason Koo on 10/15/17.
//  Copyright © 2017 jalakoo. All rights reserved.
//
//  REQ: +OnCompletions extension

import UIKit

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}

//    Add this to AppDelegate to enable these swizzles:

//    override init() {
//        super.init()
//        UIViewController.classInit
//    }

extension UIViewController {
    
    static let classInit: Void = {
        let originalSelector = #selector(viewDidAppear(_:))
        let swizzledSelector = #selector(swizzledViewDidAppear(_:))
        swizzling(UIViewController.self, originalSelector, swizzledSelector)
        
        let originalViewDidLoadSelector = #selector(viewDidLoad)
        let swizzledViewDidLoadSelector = #selector(swizzledViewDidLoad)
        swizzling(UIViewController.self, originalViewDidLoadSelector, swizzledViewDidLoadSelector)
        
        let originalViewWillAppear = #selector(viewWillAppear(_:))
        let swizzledViewWillAppear = #selector(swizzledViewWillAppear(_:))
        swizzling(UIViewController.self, originalViewWillAppear, swizzledViewWillAppear)
        
        let originalViewWillDisappear = #selector(viewWillDisappear(_:))
        let swizzledViewWillDisappear = #selector(swizzledViewWillDisappear(_:))
        swizzling(UIViewController.self, originalViewWillDisappear, swizzledViewWillDisappear)
    }()
    
    // MARK: ViewDidAppear
    @objc func swizzledViewDidAppear(_ animated: Bool) {
        triggerOnViewDidAppearCompletion()
        // Call the original viewDidAppear - which now has the swizzledViewDidAppear signature
        swizzledViewDidAppear(animated)
    }
    
    func onViewDidAppear(completion:@escaping NSObjectEmptyBlock) {
        onEmptyBlock(named: "viewDidAppear", completion)
    }
    
    func triggerOnViewDidAppearCompletion() {
        triggerEmptyBlock(named: "viewDidAppear")
    }
    
    // MARK: ViewDidLoad
    @objc func swizzledViewDidLoad() {
        triggerOnViewDidLoadCompletion()
        // Call the original viewDidAppear - which now has the swizzledViewDidAppear signature
        swizzledViewDidLoad()
    }
    
    func onViewDidLoad(completion:@escaping NSObjectEmptyBlock) {
        onEmptyBlock(named: "viewDidLoad", completion)
    }
    
    func triggerOnViewDidLoadCompletion() {
        triggerEmptyBlock(named: "viewDidLoad")
    }
    
    // MARK: ViewWillAppear
    @objc func swizzledViewWillAppear(_ animated: Bool) {
        triggerOnViewWillAppearCompletion()
        // Call the original - which now has the swizzledViewWillAppear signature
        swizzledViewWillAppear(animated)
    }
    
    func onViewWillAppear(completion:@escaping NSObjectEmptyBlock) {
        onEmptyBlock(named: "viewWillAppear", completion)
    }
    
    func triggerOnViewWillAppearCompletion() {
        triggerEmptyBlock(named: "viewWillAppear")
    }
    
    // MARK: ViewWillDisappear
    @objc func swizzledViewWillDisappear(_ animated: Bool) {
        triggerOnViewWillDisappearCompletion()
        // Call the original - which now has the swizzledViewWillAppear signature
        swizzledViewWillDisappear(animated)
    }
    
    func onViewWillDisappear(completion:@escaping NSObjectEmptyBlock) {
        onEmptyBlock(named: "viewDidDisappear", completion)
    }
    
    func triggerOnViewWillDisappearCompletion() {
        triggerEmptyBlock(named: "viewDidDisappear")
    }
}
