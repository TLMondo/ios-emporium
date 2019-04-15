//
//  AsyncState.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/24/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

struct AsyncState: Codable {
    var config: Config = Config()
    var conference: Conference?
    var email: String?
    var token: String?
    var selections: [ProductSelection] = [ProductSelection]()

    init() {
        self.config = Config()
    }
    
    init(config: Config) {
        self.config = config
    }
    
    enum CodingKeys: String, CodingKey {
        case config = "config"
        case conference = "conference"
        case email = "email"
        case token = "token"
        case selections = "selections"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        config = try values.decode(Config.self, forKey: .config)
        conference = try values.decodeIfPresent(Conference.self, forKey: .conference)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        selections = try values.decode([ProductSelection].self, forKey: .selections)
    }

    func save(success: NSObjectEmptyBlock?,
              failure: NSObjectGenericBlock<Error>?) {
        Persistence.save(self,
                         filename: "state",
                         success: success,
                         error: failure)
    }
    
    static func current(success: @escaping NSObjectGenericBlock<AsyncState>,
                        failure: @escaping NSObjectGenericBlock<Error>) {
        Persistence.load(filename: "state",
                         type: AsyncState.self,
                         success: success,
                         error: failure)
    }
}
