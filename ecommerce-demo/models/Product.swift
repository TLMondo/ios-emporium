//
//  Product.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/24/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

struct Product : Codable {

    var id : String?
    let name : String?
    let description : String?
    let image_name : String?
    let image_url : String?
    let value : Int?
    let snowshoes : String?
    let title : String?
    let icon : String?
    let category : String?
    let max_per_user : String?
    let title_earned : String?
    let conference_id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case description = "description"
        case image_name = "image_name"
        case image_url = "image_url"
        case value = "value"
        case snowshoes = "snowshoes"
        case title = "title"
        case icon = "icon"
        case category = "category"
        case max_per_user = "max_per_user"
        case title_earned = "title_earned"
        case conference_id = "conference_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image_name = try values.decodeIfPresent(String.self, forKey: .image_name)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        snowshoes = try values.decodeIfPresent(String.self, forKey: .snowshoes)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        max_per_user = try values.decodeIfPresent(String.self, forKey: .max_per_user)
        title_earned = try values.decodeIfPresent(String.self, forKey: .title_earned)
        conference_id = try values.decodeIfPresent(String.self, forKey: .conference_id)
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        if lhs.id != rhs.id { return false }
        return true
    }

}

extension Product : Hashable {
    
    var hashValue : Int {
        guard let hash = id?.hashValue else {
            return 0
        }
        return hash
    }
}

extension Array where Element == Product {
    
    func idsOnly() -> [String] {
        var results = [String]()
        for product in self {
            // Should really just make id non-optional
            guard let pid = product.id else {
                continue
            }
            results.append(pid)
        }
        return results
    }
    
    func productFor(id: String) -> Product? {
        return self.first(where: { (product) -> Bool in
            product.id == id
        })
    }
    
    func totalValue() -> Int {
        let result = self.reduce(0, {$0 + ($1.value ?? 0)})
        return result
    }
    
    func from(ids: [String]) -> [Product] {
        var result = [Product]()
        for id in ids {
            guard let product = self.productFor(id: id) else {
                continue
            }
            result.append(product)
        }
        return result
    }
    
    func withValuesBetween(_ minValue: Int, _ maxValue: Int) -> [Product] {
        var result = [Product]()
        
        for product in self {
            if let v = product.value,
                v >= minValue && v <= maxValue {
                result.append(product)
            }
        }
        return result
    }
}
