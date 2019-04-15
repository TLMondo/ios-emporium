//
//  Fetch.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/24/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation
import CodableFirebase

enum FetchError: Error {
    case firebaseManagerNotEnabled
    case unimplmentedReturnType
    case invalidUrlString
    case noResponseData
    case noHTTPResponse
    case non200Response
    case noInternetNoSavedFile
    case retryExceeded
    case couldntLoadData
    case emptyResponseData
}

class Fetch {
    
    static var prefix: String = ""
    static var suffix: String = ""
    static var token: Token?

    class func getToken(url: URL) -> String? {
        return "token"
    }
    
//    class func urlFromUrlStringPath(_ path: String) -> URL? {
//        var finalString = "\(prefix)\(path)"
//        if let t = token?.value {
//            finalString += "&token=\(t)"
//        }
//        return URL(string: finalString)
//    }

    class func getProducts(success: @escaping NSObjectGenericBlock<[Product]>,
                           error: @escaping NSObjectGenericBlock<Error>) {
        error(FetchError.unimplmentedReturnType)
    }
    
//    class func getProducts(success: @escaping NSObjectGenericBlock<[Product]>,
//                           error: @escaping NSObjectGenericBlock<Error>) {
//        guard let db = FirebaseManager.shared.db else {
//            error(FetchError.firebaseManagerNotEnabled)
//            return
//        }
//        db.collection("products").getDocuments() { (querySnapshot, err) in
//            if let e = err {
//                error(e)
//                return
//            }
//            guard let array = querySnapshot?.documents else {
//                error(FetchError.noResponseData)
//                return
//            }
//
//            // snapshot.documents consists of .documentId and .data() which contains dictionary of object
//            var responseArray = Array<Product>()
//            for document in array {
//                guard var product = try? FirestoreDecoder().decode(Product.self, from: document.data()) else {
//                    continue
//                }
//                product.id = document.documentID
//                responseArray.append(product)
//            }
//
//            success(responseArray)
//        }
//    }
    
    class func getWallet() {
        // get products in wallet
    }
    
    class func getPickups() {
        // get products available for pickup
    }
    
    class func getCart() {
        // get products in cart
    }
    
    
}
