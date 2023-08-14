//
//  SchoolInfo.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct StaffInfo: XMLObjectDeserialization {
        public var name: String
        public var email: String
        public var title: String
        public var phone: String
        public var extn: String
        public var staffGU: String

        public static func deserialize(_ element: XMLIndexer) throws -> StaffInfo {
            StaffInfo(name: try element.value(ofAttribute: "Name"),
                      email: try element.value(ofAttribute: "EMail"),
                      title: try element.value(ofAttribute: "Title"),
                      phone: try element.value(ofAttribute: "Phone"),
                      extn: try element.value(ofAttribute: "Extn"),
                      staffGU: try element.value(ofAttribute: "StaffGU"))
        }
    }

    public struct SchoolInfo: XMLObjectDeserialization {
        public var school: String
        public var principal: String
        public var address: String
        public var address2: String
        public var city: String
        public var state: String
        public var zip: String
        public var phone: String
        public var phone2: String
        public var homepage: URL?
        public var principalEmail: String
        public var principalGU: String
        public var staffList: [StaffInfo]

        public static func deserialize(_ element: XMLIndexer) throws -> SchoolInfo {
            let info = element["StudentSchoolInfoListing"]

            return SchoolInfo(school: try info.value(ofAttribute: "School"),
                              principal: try info.value(ofAttribute: "Principal"),
                              address: try info.value(ofAttribute: "SchoolAddress"),
                              address2: try info.value(ofAttribute: "SchoolAddress2"),
                              city: try info.value(ofAttribute: "SchoolCity"),
                              state: try info.value(ofAttribute: "SchoolState"),
                              zip: try info.value(ofAttribute: "SchoolZip"),
                              phone: try info.value(ofAttribute: "Phone"),
                              phone2: try info.value(ofAttribute: "Phone2"),
                              homepage: URL(string: try info.value(ofAttribute: "URL")),
                              principalEmail: try info.value(ofAttribute: "PrincipalEmail"),
                              principalGU: try info.value(ofAttribute: "PrincipalGu"),
                              staffList: try info["StaffLists"]["StaffList"].value())
        }
    }
}

extension StudentVueApi.SchoolInfo {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
