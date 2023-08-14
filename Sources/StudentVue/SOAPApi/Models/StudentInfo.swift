//
//  StudentInfo.swift
//  
//
//  Created by TheMoonThatRises on 4/12/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct EmergencyContact: XMLObjectDeserialization {
        public var name: String
        public var relationship: String
        public var homePhone: String
        public var workPhone: String
        public var otherPhone: String
        public var mobilePhone: String

        public static func deserialize(_ element: XMLIndexer) throws -> EmergencyContact {
            EmergencyContact(name: try element.value(ofAttribute: "Name"),
                             relationship: try element.value(ofAttribute: "Relationship"),
                             homePhone: try element.value(ofAttribute: "HomePhone"),
                             workPhone: try element.value(ofAttribute: "WorkPhone"),
                             otherPhone: try element.value(ofAttribute: "OtherPhone"),
                             mobilePhone: try element.value(ofAttribute: "MobilePhone"))
        }
    }

    public struct PhysicianInfo: XMLObjectDeserialization {
        public var name: String
        public var hospital: String
        public var phone: String
        public var extn: String

        public static func deserialize(_ element: XMLIndexer) throws -> PhysicianInfo {
            PhysicianInfo(name: try element.value(ofAttribute: "Name"),
                          hospital: try element.value(ofAttribute: "Hospital"),
                          phone: try element.value(ofAttribute: "Phone"),
                          extn: try element.value(ofAttribute: "Extn"))
        }
    }

    public struct DentistInfo: XMLObjectDeserialization {
        public var name: String
        public var office: String
        public var phone: String
        public var extn: String

        public static func deserialize(_ element: XMLIndexer) throws -> DentistInfo {
            DentistInfo(name: try element.value(ofAttribute: "Name"),
                        office: try element.value(ofAttribute: "Office"),
                        phone: try element.value(ofAttribute: "Phone"),
                        extn: try element.value(ofAttribute: "Extn"))
        }
    }

    public struct UserDefinedItem: XMLObjectDeserialization {
        public var itemLabel: String
        public var itemType: String
        public var sourceObject: String
        public var sourceElement: String
        public var vcid: String
        public var value: String

        public static func deserialize(_ element: XMLIndexer) throws -> UserDefinedItem {
            UserDefinedItem(itemLabel: try element.value(ofAttribute: "ItemLabel"),
                            itemType: try element.value(ofAttribute: "ItemType"),
                            sourceObject: try element.value(ofAttribute: "SourceObject"),
                            sourceElement: try element.value(ofAttribute: "SourceElement"),
                            vcid: try element.value(ofAttribute: "VCID"),
                            value: try element.value(ofAttribute: "Value"))
        }
    }

    public struct StudentInfo: XMLObjectDeserialization {
        public var lockerInfoRecords: String? // TODO: Find data type
        public var formattedName: String
        public var permID: String
        public var gender: String
        public var grade: String
        public var address: String
        public var lastNameGoesBy: String?
        public var nickname: String?
        public var birthDate: Date
        public var email: String
        public var phone: String
        public var homeLanguage: String
        public var currentSchool: String
        public var track: String? // TODO: Find data type
        public var homeRoomTeacher: String
        public var homeRoomTeacherEmail: String
        public var homeRoomTeacherGU: String
        public var orgYearGU: String
        public var homeRoom: String
        public var counselorName: String
        public var photo: String?
        public var emergencyContacts: [EmergencyContact]
        public var physicianInfo: PhysicianInfo
        public var dentistInfo: DentistInfo
        public var userDefinedItems: [UserDefinedItem]

        public static func deserialize(_ element: XMLIndexer) throws -> StudentInfo {
            let studentInfo = element["StudentInfo"]

            return StudentInfo(formattedName: try studentInfo["FormattedName"].value(),
                               permID: try studentInfo["PermID"].value(),
                               gender: try studentInfo["Gender"].value(),
                               grade: try studentInfo["Grade"].value(),
                               address: try studentInfo["Address"].value(),
                               lastNameGoesBy: try? studentInfo["LastNameGoesBy"].value(),
                               nickname: try? studentInfo["NickName"].value(),
                               birthDate: try studentInfo["BirthDate"].value(),
                               email: try studentInfo["EMail"].value(),
                               phone: try studentInfo["Phone"].value(),
                               homeLanguage: try studentInfo["HomeLanguage"].value(),
                               currentSchool: try studentInfo["CurrentSchool"].value(),
                               homeRoomTeacher: try studentInfo["HomeRoomTch"].value(),
                               homeRoomTeacherEmail: try studentInfo["HomeRoomTchEMail"].value(),
                               homeRoomTeacherGU: try studentInfo["HomeRoomTchStaffGU"].value(),
                               orgYearGU: try studentInfo["OrgYearGU"].value(),
                               homeRoom: try studentInfo["HomeRoom"].value(),
                               counselorName: try studentInfo["CounselorName"].value(),
                               photo: try? studentInfo["Photo"].value(),
                               emergencyContacts: try studentInfo["EmergencyContacts"]["EmergencyContact"].value(),
                               physicianInfo: try studentInfo["Physician"].value(),
                               dentistInfo: try studentInfo["Dentist"].value(),
                               userDefinedItems: try studentInfo["UserDefinedGroupBoxes"]["UserDefinedGroupBox"]["UserDefinedItems"].children.map { try $0.value() })
        }
    }
}

extension StudentVueApi.StudentInfo {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
