//
//  Districts.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct DistrictInfo: XMLObjectDeserialization {
        /// ID of the district.
        public var districtID: String

        /// Name of the district.
        public var districtName: String

        /// Address of the district.
        public var districtAddress: String

        /// StudentVue URL address.
        public var districtURL: URL

        public static func deserialize(_ element: XMLIndexer) throws -> DistrictInfo {
            try DistrictInfo(districtID: element.value(ofAttribute: "DistrictID"),
                             districtName: element.value(ofAttribute: "Name"),
                             districtAddress: element.value(ofAttribute: "Address"),
                             districtURL: URL(string: element.value(ofAttribute: "PvueURL"))!)
        }
    }

    public struct Districts: XMLObjectDeserialization {
        /// List of districts.
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

extension StudentVueApi.DistrictInfo: Hashable, Identifiable {
    public var id: String {
        districtID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(districtID)
    }

    public static func == (lhs: StudentVueApi.DistrictInfo, rhs: StudentVueApi.DistrictInfo) -> Bool {
        lhs.id == rhs.id
    }
}
