/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Sponsor : Codable {
	let id : String?
	let name : String?
	let description : String?
	let image_local : String?
	let level : String?
	let url : String?
	let booth_message : String?
	let swag_message : String?
	let demo_message : String?
	let conference_ids : [String]?
	let image_url : String?
	let priority : String?
	let consent_message : String?
	let url_link : String?
	let created_at : String?
	let updated_at : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case description = "description"
		case image_local = "image_local"
		case level = "level"
		case url = "url"
		case booth_message = "booth_message"
		case swag_message = "swag_message"
		case demo_message = "demo_message"
		case conference_ids = "conference_ids"
		case image_url = "image_url"
		case priority = "priority"
		case consent_message = "consent_message"
		case url_link = "url_link"
		case created_at = "created_at"
		case updated_at = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		image_local = try values.decodeIfPresent(String.self, forKey: .image_local)
		level = try values.decodeIfPresent(String.self, forKey: .level)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		booth_message = try values.decodeIfPresent(String.self, forKey: .booth_message)
		swag_message = try values.decodeIfPresent(String.self, forKey: .swag_message)
		demo_message = try values.decodeIfPresent(String.self, forKey: .demo_message)
		conference_ids = try values.decodeIfPresent([String].self, forKey: .conference_ids)
		image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
		priority = try values.decodeIfPresent(String.self, forKey: .priority)
		consent_message = try values.decodeIfPresent(String.self, forKey: .consent_message)
		url_link = try values.decodeIfPresent(String.self, forKey: .url_link)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
	}

}
