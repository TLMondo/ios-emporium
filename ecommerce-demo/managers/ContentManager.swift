//
//  ContentManager.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 11/2/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let RequestNewContent = Notification.Name("RequestNewContent")
    static let RequestTransactions = Notification.Name("RequestTransactions")
}

enum ContentManagerError : Error {
    case stateMissingEmail
    case stateMissingToken
    case stateMissingConferenceId
}

class ContentManager : NSObject {
    
    let email : String
    let token : String
    let conferenceId: String
    let dvManager = DigitalVelocityManager()
    var products = [Product]()
    var sponsors = [Sponsor]()
    var transactions = [Transaction]()
    var newProducts : NSObjectGenericBlock<[Product]>?
    var newSponsors: NSObjectGenericBlock<[Sponsor]>?
    var newTransactions: NSObjectGenericBlock<[Transaction]>?
    var onError: NSObjectGenericBlock<Error>?

    init?(state: AsyncState) {
        guard let e = state.email else {
//            throw ContentManagerError.stateMissingEmail
            return nil
        }
        guard let t = state.token else {
//            throw ContentManagerError.stateMissingToken
            return nil
        }
        guard let c = state.conference?.id else {
//            throw ContentManagerError.stateMissingConferenceId
            return nil
        }
        self.email = e
        self.token = t
        self.conferenceId = c
        super.init()
        self.enable()
    }
    
    func enable() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateAll),
                                               name: .RequestNewContent,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTransactions),
                                               name: .RequestTransactions,
                                               object: nil)
    }
    
    @objc func updateAll() {
        
        getAllSponsors(email: email,
                       conferenceId: conferenceId,
                       token: token,
                       success: nil,
                       failure: nil)
        
        getAllProducts(token: token,
                       conferenceId: conferenceId,
                       success: nil,
                       failure: nil)
        
        updateTransactions()
    }
    
    @objc func updateTransactions() {
        getAllTransactions(email: email,
                           conferenceId: conferenceId,
                           token: token,
                           success: nil,
                           failure: nil)
    }
    
    func getAllProducts(token: String,
                        conferenceId: String,
                        success: NSObjectEmptyBlock?,
                        failure: NSObjectGenericBlock<Error>?) {
        dvManager.getProducts(token: token,
                              conferenceId: conferenceId,
                              success: { [weak self] (newProducts) in
                self?.products = newProducts
                self?.newProducts?(newProducts)
                success?()
            }, failure: { (error) in
                failure?(error)
        })
    }
    
    func getAllTransactions(email: String,
                            conferenceId: String,
                            token: String,
                            success: NSObjectEmptyBlock?,
                            failure: NSObjectGenericBlock<Error>?) {
        dvManager.getTransactions(email: email,
                                  conferenceId: conferenceId,
                                  token: token,
                                  additionalParams: "&min_status=0",
                                  success: { [weak self] (newTransactions) in
                self?.transactions = newTransactions
                self?.newTransactions?(newTransactions)
                success?()
            }, failure: { (error) in
                failure?(error)
        })
    }
    
    func getAllSponsors(email: String,
                        conferenceId: String,
                        token: String,
                        success: NSObjectEmptyBlock?,
                        failure: NSObjectGenericBlock<Error>?){
        
        dvManager.getSponsors(token: token,
                              success: { [weak self] (newSponsors) in
            self?.sponsors = newSponsors
            self?.newSponsors?(newSponsors)
            success?()
        }, failure: { (error) in
            failure?(error)
        })
    }
    
    func addToCart(products: [Product],
                   sponsorId: String,
                   success: @escaping NSObjectEmptyBlock,
                   failure: @escaping NSObjectGenericBlock<Error>) {
        let productIds = products.idsOnly()
        dvManager.addTransactions(forProductIds: productIds,
                                  sponsorId: sponsorId,
                                  email: email,
                                  token: token,
                                  conferenceId: conferenceId,
                                  status: 0,
                                  success: success,
                                  failure: failure)
    }
    
    func deleteTransactions(transactions: [Transaction],
                           success: @escaping NSObjectEmptyBlock,
                           failure: @escaping NSObjectGenericBlock<Error>) {
        dvManager.deleteTransactions(conferenceId: conferenceId,
                                     token: token,
                                     transactions: transactions,
                                     success: success,
                                     failure: failure)
    }
    
    func checkout(success: @escaping NSObjectEmptyBlock,
                  failure: @escaping NSObjectGenericBlock<Error>) {
        let incartTransactions = transactions.withStatus(.incart)
        dvManager.updateTransactionsStatusCall(email: email,
                                               token: token,
                                               conferenceId: conferenceId,
                                               transactions: incartTransactions,
                                               newStatus: 10,
                                               success: success,
                                               failure: failure)
    }
    
    // Current Beastcoins earned by user
    func availableBeastcoins() -> Int {
        return beastcoinsFor(transactions.withStatusBetween(.purchased, .delivered))
    }
    
    // Total available beastcoins after including in-cart items
    func possibleBeastcoins() -> Int {
        return beastcoinsFor(transactions.withStatusBetween(.incart, .delivered))
    }
    
    func inCartBeastcoins() -> Int {
        return beastcoinsFor(transactions.withStatus(.incart))
    }
    
    func beastcoinsFor(_ transactions: [Transaction]) -> Int {
        let pids = transactions.productIds()
        let ps = products.from(ids: pids)
        let total = ps.totalValue()
        return total
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
