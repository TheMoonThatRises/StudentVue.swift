//
//  API.swift
//  
//
//  Created by TheMoonThatRises on 3/22/23.
//

import Foundation

extension StudentVueScraper {
    struct APIData: Decodable {
        var html: String
    }

    struct APIResult: Decodable {
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

    struct API: Decodable {
        enum CodingKeys: String, CodingKey {
            case result = "d"
        }

        var result: APIResult
    }
}
