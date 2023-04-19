//
//  SchoolInfo.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

struct StaffInfo: XMLObjectDeserialization {
    var name: String
    var email: String
    var title: String
    var phone: String
    var extn: String
    var staffGU: String

    static func deserialize(_ element: XMLIndexer) throws -> StaffInfo {
        StaffInfo(name: try element.value(ofAttribute: "Name"),
                  email: try element.value(ofAttribute: "EMail"),
                  title: try element.value(ofAttribute: "Title"),
                  phone: try element.value(ofAttribute: "Phone"),
                  extn: try element.value(ofAttribute: "Extn"),
                  staffGU: try element.value(ofAttribute: "StaffGU"))
    }
}

struct SchoolInfo: XMLObjectDeserialization {
    var school: String
    var principal: String
    var address: String
    var address2: String
    var city: String
    var state: String
    var zip: String
    var phone: String
    var phone2: String
    var homepage: URL?
    var principalEmail: String
    var principalGU: String
    var staffList: [StaffInfo]

    static func deserialize(_ element: XMLIndexer) throws -> SchoolInfo {
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

extension SchoolInfo {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
