//
//  Districts.swift
//  
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct DistrictInfo: XMLObjectDeserialization {
        public var districtID: String
        public var districtName: String
        public var districtAddress: String
        public var districtURL: URL

        public static func deserialize(_ element: XMLIndexer) throws -> DistrictInfo {
            try DistrictInfo(districtID: element.value(ofAttribute: "DistrictID"),
                             districtName: element.value(ofAttribute: "Name"),
                             districtAddress: element.value(ofAttribute: "Address"),
                             districtURL: URL(string: element.value(ofAttribute: "PvueURL"))!)
        }
    }

    public struct Districts: XMLObjectDeserialization {
        public var districts: [DistrictInfo]

        public static func deserialize(_ element: XMLIndexer) throws -> Districts {
            try Districts(districts: element["DistrictLists"]["DistrictInfos"].children.map { try $0.value() })
        }
    }
}

extension StudentVueApi.Districts {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
