//
//  SchoolInfo.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    /// Staff information.
    public struct StaffInfo: XMLObjectDeserialization {
        /// Name of the staff member.
        public var name: String

        /// Email of the staff member.
        public var email: String

        /// Position of the staff member.
        public var title: String

        /// Phone number of the staff member.
        public var phone: String

        /// Extension for the phone number.
        public var extn: String

        /// Staff GU.
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

    /// Full information about the school.
    public struct SchoolInfo: XMLObjectDeserialization {
        /// Name of the school.
        public var school: String

        /// Name of the principal.
        public var principal: String

        /// Address of the school.
        public var address: String

        /// Second address of the school.
        public var address2: String

        /// City location of the school.
        public var city: String

        /// State the school is located in.
        public var state: String

        /// School zip code.
        public var zip: String

        /// School phone number.
        public var phone: String

        /// School Fax.
        public var phone2: String

        /// School homepage.
        public var homepage: URL?

        /// Email of the school's principal.
        public var principalEmail: String

        /// GU of the principal.
        public var principalGU: String

        /// List of staff members at the school.
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

extension StudentVueApi.StaffInfo: Identifiable, Equatable {
    public var id: String {
        staffGU
    }

    public static func == (lhs: StudentVueApi.StaffInfo, rhs: StudentVueApi.StaffInfo) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.SchoolInfo: Identifiable, Equatable {
    public var id: String {
        school + principalGU
    }

    public static func == (lhs: StudentVueApi.SchoolInfo, rhs: StudentVueApi.SchoolInfo) -> Bool {
        lhs.id == rhs.id
    }
}
