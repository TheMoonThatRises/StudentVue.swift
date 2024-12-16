//
//  API.swift
//  StudentVue
//
//  Created by Peter Duanmu on 3/22/23.
//

import Foundation

extension StudentVueScraper {
    internal struct APIData: Decodable {
        var html: String
    }

    internal struct APIResult: Decodable {
        enum CodingKeys: String, CodingKey {
            case type = "__type"
            case error = "Error"
            case data = "Data"
            case dataType = "DataType"
        }

        var type: String
        var error: String?
        var data: APIData
        var dataType: String
    }

    /// This parses scraped data from StudentVue's website and uses `CodingKeys` to convert
    /// unlegable keys into more obvious names.
    internal struct API: Decodable {
        enum CodingKeys: String, CodingKey {
            case result = "d"
        }

        var result: APIResult
    }
}
