//
//  DigitalVelocityManager.swift
//  ecommerce-demo
//
//  Created by Christina on 9/13/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

enum DigitalVelocityManagerError: Error {
    case malformedURL
    case malformedResponse
    case non200Response
    case noDataInResponse
    case noResultsInData
    case cannotSerializeJSON
    case cannotStringifyJSON
    case invalidLogin
}

class DigitalVelocityManager: BaseManager {

    let baseUrl = "https://digitalvelocity.herokuapp.com/v1/"

    static let shared = DigitalVelocityManager() // create mock instead?

    // Sample server response for token: Dictionary
    //            {
    //                "token": "eyJhbG6iOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyZXN1bHRzIjpbeyJpZCI6IkFFd0twdnFHIiwiZW1haWwiOiJqYXNvbi5rb29AdGVhbGl1bS5jb20iLCJwYXNza2V5IjoiJDJiJDEwJHk4QVlQSm1rbEg4cDZVa2lpR296UWVCEURMT1pwWWNuQXpEcHoyVlZaS3RHL3dScWdtZW1PIn1dLCJpYXQiOjE1Mzg0MjMwMDd9.JX8cxy_LIGYI70mH5dmHS4uAYK9RNN8UqPCNeZcAUMH",
    //                "expires_at": 4131302400
    //            }
    func getToken(email: String,
                  conferenceId: String,
                  password: String,
                  success: @escaping NSObjectGenericBlock<String>,
                  failure: @escaping NSObjectGenericBlock<Error>) {

        // TODO: Hash password here using BCryptSwift
        
        let urlString = baseUrl + "\(String(describing: conferenceId))/auth?email=\(email)&passkey=\(password)"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        // This presumes data is a json string
        // TODO: Update this if data is NOT a json dictionary string - decoded data as string in the makeSessionCall func
        postSessionCall(url: url,
                        success: { (data: String) in

                            let dataDictionary = self.convertToDictionary(text: data)
                            guard let token = dataDictionary?["token"] as? String else {
                                failure(DigitalVelocityManagerError.invalidLogin)
                                return
                            }
                            success(token)

        }, failure: failure)
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    //  Sample server response for Conferences. JSON Array
//        [
//            {
//            "name": "DV London",
//            "image_url": "http://3qh0ao4baryywogcj2huk6rm3b.wpengine.netdna-cdn.com/wp-content/uploads/2018/02/shutterstock_92655643-e1518197754999.jpg",
//            "url_link": "",
//            "timestamp_start": 1528786800,
//            "timestamp_end": 1528909200
//            },
//            {
//            "name": "DV San Francisco",
//            "image_url": "http://3qh0ao4baryywogcj2huk6rm3b.wpengine.netdna-cdn.com/wp-content/uploads/2016/11/dv17_sf_bg_01.jpg",
//            "url_link": "",
//            "timestamp_start": 1539068400,
//            "timestamp_end": 1539190800
//            }
//        ]
    func getConferences(token: String,
                        success: @escaping NSObjectGenericBlock<[Conference]>,
                        failure: @escaping NSObjectGenericBlock<Error>) {

        let urlString = baseUrl + "conferences/list?token=\(token)"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        makeSessionCall(url: url,
                        success: { (JSONString: String) in
                            do {
                                if let jsonData = JSONString.data(using: .utf8) {
                                    let conferenceData = try? JSONDecoder().decode([Conference].self, from: jsonData)
                                    if let conference = conferenceData {
                                        success(conference)
                                    }
                                                                    }
                                // TODO: Data will be a json array, need to convert that into Swift [Conference]
                                // TODO: See https://hackernoon.com/codable-in-swift4-e24f7cc253da for good example of converting json strings to codable objects
                                // TODO: Return array to success(array)
                            } catch let error {
                                failure(error)
                            }
                        }) { (error) in
            failure(error)
        }
    }


    // Sample transactions reponse: Dictionary with array contents in 'results' key
    //    {
    //        "results": [
    //        {
    //        "product_id": "C6kzuZ-c",
    //        "timestamp_utc": 1536787761000,
    //        "user_id": "jason.koo@tealium.com",
    //        "id": "zJPlv1TQ",
    //        "sponsor_id": null,
    //        "conference_id": "a39w9jfw",
    //        "purchased_at_utc": 1537165736,
    //        "status": 0,
    //        "updated_at": "2018-09-23T04:11:25.263Z",
    //        "created_at": null
    //        },
    //        {
    //        "product_id": "7ve3XlV_",
    //        "timestamp_utc": 1536787771000,
    //        "user_id": "jason.koo@tealium.com",
    //        "id": "hB_RGF5w",
    //        "sponsor_id": null,
    //        "conference_id": "a39w9jfw",
    //        "purchased_at_utc": 1537165736,
    //        "status": 0,
    //        "updated_at": "2018-09-23T04:11:25.263Z",
    //        "created_at": "2018-09-17T01:08:21.618Z"
    //        }
    //    }
    func getTransactions(email: String,
                         conferenceId: String,
                         token: String,
                         additionalParams: String?,
                         success: @escaping NSObjectGenericBlock<[Transaction]>,
                         failure: @escaping NSObjectGenericBlock<Error>) {
        let urlString = baseUrl + "\(conferenceId)/transactions/list?user_id=\(email)&token=\(token)\(additionalParams ?? "")"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        makeSessionCall(url: url,
                        success: { (JSONString: String) in
                            do {
                                if let jsonData = JSONString.data(using: .utf8)
                                {
//                                    let transactionData = try? JSONDecoder().decode([String:Data].self, from: jsonData)
//                                    guard let results = transactionData else {
//                                        failure(DigitalVelocityError.noResultsInData)
//                                        return
//                                    }
                                    let resultsData = try? JSONDecoder().decode([Transaction].self, from: jsonData)
                                    guard let resultsFinal = resultsData else {
                                        failure(DigitalVelocityManagerError.noResultsInData)
                                        return
                                    }
                                    success(resultsFinal)
                                }
                            } catch let error {
                                failure(error)
                            }
        }) { (error) in
            failure(error)
        }
        
        
    }

    // Sample Sponsors reponse: Array of objects
    //    [
    //        {
    //        "id": "42BvjB4W",
    //        "name": "Blast",
    //        "description": "Blast helps organizations identify and solve unique business problems through analytics and digital marketing intelligence.",
    //        "image_local": null,
    //        "level": "Gold",
    //        "url": null,
    //        "booth_message": null,
    //        "swag_message": null,
    //        "demo_message": null,
    //        "conference_ids": [
    //        "a39w9jfw"
    //        ],
    //        "image_url": "https://res.cloudinary.com/hwnqzsuud/image/upload/v1528165585/blast_header_logo.png",
    //        "priority": null,
    //        "consent_message": "Blast-Share contact data",
    //        "url_link": "https://www.blastam.com/",
    //        "created_at": "2018-09-14T00:00:00.000Z",
    //        "updated_at": "2018-09-14T00:00:00.000Z"
    //        }
    //    ]
    func getSponsors(token: String,
                     success: @escaping NSObjectGenericBlock<[Sponsor]>,
                     failure: @escaping NSObjectGenericBlock<Error>) {
        let urlString = baseUrl + "sponsors/list?token=\(token)"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        makeSessionCall(url: url,
                        success: { (JSONString: String) in
                            // TODO: Remove do-catch
                            // TODO: Use guard statements to verify
                            do {
                                if let jsonData = JSONString.data(using: .utf8)
                                {
                                    let sponsorsData = try? JSONDecoder().decode([Sponsor].self, from: jsonData)
                                    if let sponsors = sponsorsData {
                                        success(sponsors)
                                    }
                                }
                            } catch let error {
                                failure(error)
                            }
        }) { (error) in
            failure(error)
        }

    }

    // Sample transactions reponse: Array of objects
    //    [
    //        {
    //        "id": "C6kzuZ-c",
    //        "name": "Agree to meetings",
    //        "description": "Agree to 5 meetings during registration",
    //        "image_name": null,
    //        "image_url": null,
    //        "value": 10,
    //        "snowshoes": null,
    //        "title": null,
    //        "icon": null,
    //        "category": null,
    //        "max_per_user": null,
    //        "title_earned": null,
    //        "conference_id": "a39w9jfw"
    //        },
    //        {
    //        "id": "7ve3XlV_",
    //        "name": "Attend roundtable",
    //        "description": "Attend roundtable session",
    //        "image_name": null,
    //        "image_url": null,
    //        "value": 20,
    //        "snowshoes": null,
    //        "title": null,
    //        "icon": null,
    //        "category": null,
    //        "max_per_user": null,
    //        "title_earned": null,
    //        "conference_id": "a39w9jfw"
    //        }
    //    ]
    func getProducts(token: String,
                     conferenceId: String,
                     success: @escaping NSObjectGenericBlock<[Product]>,
                     failure: @escaping NSObjectGenericBlock<Error>) {
        let urlString = baseUrl + "\(conferenceId)/products/list?token=\(token)"
        print(urlString)
        // TODO: Rest same as getConferences, just update block handling response data
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        makeSessionCall(url: url,
                        success: { (JSONString: String) in
                            // TODO: Remove do-catch
                            // TODO: Use guard statements to verify
                            do {
                                if let jsonData = JSONString.data(using: .utf8)
                                {
                                    let productData = try? JSONDecoder().decode([Product].self, from: jsonData)
                                    if let products = productData {
                                        success(products)
                                    }
   
                                }
                            } catch let error {
                                failure(error)
                            }
        }) { (error) in
            failure(error)
        }

    }
    
    // SAMPLE BODY JSON PAYLOAD
    //    {
    //    "user_id":"jason.koo@tealium.com",
    //    "product_ids":["_s-1HmC_"],
    //    "sponsor_id":"8AukZJU0",
    //    "new_status":0
    //    }
    func addTransactions(forProductIds: [String],
                         sponsorId: String,
                         email: String,
                         token: String,
                         conferenceId: String,
                         status: Int,
                         success: @escaping NSObjectEmptyBlock,
                         failure: @escaping NSObjectGenericBlock<Error>) {
        
        let urlString = baseUrl + "\(conferenceId)/transactions/addmany?token=\(token)"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        let payload: [String:Any] = ["user_id": email,
                                     "product_ids": forProductIds,
                                     "sponsor_id": sponsorId,
                                     "new_status": status]
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            failure(DigitalVelocityManagerError.cannotSerializeJSON)
            return
        }
        postData(url: url,
                 data: data,
                 success: success,
                 failure: failure)
        
    }
    
    func updateTransactionsStatusCall(email: String,
                                      token: String,
                                      conferenceId: String,
                                      transactions: [Transaction],
                                      newStatus: Int,
                                      success: @escaping NSObjectEmptyBlock,
                                      failure: @escaping NSObjectGenericBlock<Error>){
        
        let urlString = baseUrl + "\(conferenceId)/transactions/update?token=\(token)"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        let payload: [String:Any] = ["user_id": email,
                                     "transaction_ids": transactions.idsOnly(),
                                     "new_status": newStatus]
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            failure(DigitalVelocityManagerError.cannotSerializeJSON)
            return
        }
        postData(url: url,
                 data: data,
                 success: success,
                 failure: failure)
        
    }
    
    func deleteTransactions(conferenceId: String,
                            token: String,
                            transactions: [Transaction],
                            success: @escaping NSObjectEmptyBlock,
                            failure: @escaping NSObjectGenericBlock<Error>) {
        let urlString = baseUrl + "\(conferenceId)/transactions/delete?token=\(token)"
        guard let url = URL(string: urlString) else {
            failure(DigitalVelocityManagerError.malformedURL)
            return
        }
        let payload: [String:Any] = ["transaction_ids": transactions.idsOnly()]
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            failure(DigitalVelocityManagerError.cannotSerializeJSON)
            return
        }
        postData(url: url,
                 data: data,
                 success: success,
                 failure: failure)
    }

    // Generic URL Session call
    func makeSessionCall(url: URL,
                         success: @escaping NSObjectGenericBlock<String>,
                         failure: @escaping NSObjectGenericBlock<Error>) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                failure(error)
                return
            }
            guard let data = data else {
                failure(DigitalVelocityManagerError.noDataInResponse)
                return
            }
            
//            Log.verbose("Data received: \(data as AnyObject)")
            Log.verbose("Response received: \(String(describing: response))")

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let stringified = try JSONStringify(value: json).stringify()
                    success(stringified)
                } catch { failure(DigitalVelocityManagerError.cannotStringifyJSON) }
            } catch { failure(DigitalVelocityManagerError.cannotSerializeJSON) }
        }
        task.resume()
    }
    
    // TODO: This should really use body data
    func postSessionCall(url: URL,
                         success: @escaping NSObjectGenericBlock<String>,
                         failure: @escaping NSObjectGenericBlock<Error>) {
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
//        request.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                failure(error)
                return
            }
            guard let data = data else {
                failure(DigitalVelocityManagerError.noDataInResponse)
                return
            }
            
//            Log.verbose("Data received: \(data as AnyObject)")
            Log.verbose("Response received: \(String(describing: response))")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let stringified = try JSONStringify(value: json).stringify()
                    success(stringified)
                } catch { failure(DigitalVelocityManagerError.cannotStringifyJSON) }
            } catch { failure(DigitalVelocityManagerError.cannotSerializeJSON) }
        }
        task.resume()
    }
    
    func postData(url: URL,
                  data: Data,
                  success: @escaping NSObjectEmptyBlock,
                  failure: @escaping NSObjectGenericBlock<Error>){
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                failure(e)
                return
            }
            guard let r = response as? HTTPURLResponse else {
                failure(DigitalVelocityManagerError.malformedResponse)
                return
            }
            if r.statusCode != 200 {
                failure(DigitalVelocityManagerError.non200Response)
                return
            }
            success()
        }
        task.resume()
    }
    
}
