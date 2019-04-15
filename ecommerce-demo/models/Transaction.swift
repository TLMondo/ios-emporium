/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

enum TransactionStatus : Int {
    case canceled = -10
    case incart = 0
    case purchased = 10
    case awarded = 15
    case processing = 20
    case ready = 30
    case delivered = 40
    
    func asString() -> String {
        if self == .canceled { return "canceled".localized() }
        if self == .incart { return "incart".localized() }
        if self == .purchased { return "inqueue".localized() }
        if self == .processing { return "processing".localized() }
        if self == .ready { return "readyforpickup".localized() }
        if self == .delivered { return "delivered".localized() }
        return ""
    }
}

struct Transaction : Codable {
	let product_id : String?
	let timestamp_utc : Int?
	let user_id : String?
	let id : String?
	let sponsor_id : String?
	let conference_id : String?
	let purchased_at_utc : Int?
	let status : Int?
	let updated_at : String?
	let created_at : String?

	enum CodingKeys: String, CodingKey {

		case product_id = "product_id"
		case timestamp_utc = "timestamp_utc"
		case user_id = "user_id"
		case id = "id"
		case sponsor_id = "sponsor_id"
		case conference_id = "conference_id"
		case purchased_at_utc = "purchased_at_utc"
		case status = "status"
		case updated_at = "updated_at"
		case created_at = "created_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		product_id = try values.decodeIfPresent(String.self, forKey: .product_id)
		timestamp_utc = try values.decodeIfPresent(Int.self, forKey: .timestamp_utc)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		sponsor_id = try values.decodeIfPresent(String.self, forKey: .sponsor_id)
		conference_id = try values.decodeIfPresent(String.self, forKey: .conference_id)
		purchased_at_utc = try values.decodeIfPresent(Int.self, forKey: .purchased_at_utc)
        if let s = try values.decodeIfPresent(Int.self, forKey: .status) {
            status = s
        } else {
            status = 0
        }
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
	}
    
    func statusAsString() -> String {
        guard let s = status else {
            return ""
        }
        if s < 0 { return "canceled".localized() }
        if s == 0 { return "incart".localized() }
        if s == 10 { return "inqueue".localized() }
        if s == 15 { return "incart".localized() }
        if s == 20 { return "processing".localized() }
        if s == 30 { return "readyforpickup".localized() }
        if s == 40 { return "delivered".localized() }
        return ""
    }

}

extension Array where Element == Transaction {
    
    func productIds() -> [String] {
        var result = [String]()
        for transaction in self {
            guard let pid = transaction.product_id else {
                continue
            }
            result.append(pid)
        }
        return result
    }
    
    func idsOnly() -> [String] {
        var result = [String]()
        for transaction in self {
            guard let tid = transaction.id else {
                continue
            }
            result.append(tid)
        }
        return result
    }
    
    func withStatus(_ status: TransactionStatus) -> [Transaction] {
        return withStatusBetween(status, status)
    }
    
    func withStatusBetween(_ minStatus: TransactionStatus, _ maxStatus: TransactionStatus) -> [Transaction] {
        var result = [Transaction]()
        for transaction in self {
            if let status = transaction.status,
                status >= minStatus.rawValue && status <= maxStatus.rawValue {
                result.append(transaction)
            }
        }
        return result
    }
    
    func withStatuses(_ statuses: [TransactionStatus]) -> [Transaction] {
        var result = [Transaction]()
        for transaction in self {
            if let statusValue = transaction.status {
                for targetStatus in statuses {
                    if statusValue == targetStatus.rawValue {
                        result.append(transaction)
                    }
                }
            }
        }
        return result
    }
    
    func sortedByTimestamp() -> [Transaction] {
        let result = self.sorted(by: { $0.purchased_at_utc! > $1.purchased_at_utc!})
        return result
    }
    
}
