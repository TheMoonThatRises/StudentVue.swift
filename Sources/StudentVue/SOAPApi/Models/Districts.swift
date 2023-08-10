//
//  Districts.swift
//  
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation
import SWXMLHash

struct DistrictInfo: XMLObjectDeserialization {
    var districtID: String
    var districtName: String
    var districtAddress: String
    var districtURL: URL

    static func deserialize(_ element: XMLIndexer) throws -> DistrictInfo {
        try DistrictInfo(districtID: element.value(ofAttribute: "DistrictID"),
                         districtName: element.value(ofAttribute: "Name"),
                         districtAddress: element.value(ofAttribute: "Address"),
                         districtURL: URL(string: element.value(ofAttribute: "PvueURL"))!)
    }
}

struct Districts: XMLObjectDeserialization {
    var districts: [DistrictInfo]

    static func deserialize(_ element: XMLIndexer) throws -> Districts {
        try Districts(districts: element["DistrictLists"]["DistrictInfos"].children.map { try $0.value() })
    }
}

extension Districts {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
