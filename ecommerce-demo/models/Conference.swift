/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Conference : Codable {
  
    let id : String?
    let name : String?
    let image_url : String?
    let url_link : String?
    let timestamp_start : Int?
    let timestamp_end : Int?
    let lat : Double?
    let lon : Double?
    let venue_name : String?
    let venue_address : String?
    let wifi_name : String?
    let wifi_password : String?
    let description : String?
    let short_name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case image_url = "image_url"
        case url_link = "url_link"
        case timestamp_start = "timestamp_start"
        case timestamp_end = "timestamp_end"
        case lat = "lat"
        case lon = "lon"
        case venue_name = "venue_name"
        case venue_address = "venue_address"
        case wifi_name = "wifi_name"
        case wifi_password = "wifi_password"
        case description = "description"
        case short_name = "short_name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        url_link = try values.decodeIfPresent(String.self, forKey: .url_link)
        timestamp_start = try values.decodeIfPresent(Int.self, forKey: .timestamp_start)
        timestamp_end = try values.decodeIfPresent(Int.self, forKey: .timestamp_end)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        venue_name = try values.decodeIfPresent(String.self, forKey: .venue_name)
        venue_address = try values.decodeIfPresent(String.self, forKey: .venue_address)
        wifi_name = try values.decodeIfPresent(String.self, forKey: .wifi_name)
        wifi_password = try values.decodeIfPresent(String.self, forKey: .wifi_password)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        short_name = try values.decodeIfPresent(String.self, forKey: .short_name)
    }
    
}
