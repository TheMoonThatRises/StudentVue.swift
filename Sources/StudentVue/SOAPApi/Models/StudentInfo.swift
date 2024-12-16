//
//  StudentInfo.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/12/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    /// Emergency contacts provided by the parent of the student when registering their student
    /// through StudentVue.
    public struct EmergencyContact: XMLObjectDeserialization {
        /// Emergency contact name.
        public var name: String

        /// Relationship between the emergency contact and the student.
        public var relationship: String

        /// Home phone number.
        public var homePhone: String

        /// Work phone number.
        public var workPhone: String

        /// Other phone number.
        public var otherPhone: String

        /// Mobile phone number.
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

    /// The physican of the student submitted by the parent when registering their student
    /// through StudentVue.
    public struct PhysicianInfo: XMLObjectDeserialization {
        /// Physician name.
        public var name: String

        /// Physician working hospital.
        public var hospital: String

        /// Physician's phone number.
        public var phone: String

        /// Extension for the phone number.
        public var extn: String

        public static func deserialize(_ element: XMLIndexer) throws -> PhysicianInfo {
            PhysicianInfo(name: try element.value(ofAttribute: "Name"),
                          hospital: try element.value(ofAttribute: "Hospital"),
                          phone: try element.value(ofAttribute: "Phone"),
                          extn: try element.value(ofAttribute: "Extn"))
        }
    }

    /// The dentist of the student submitted by the parent when registering their student
    /// through StudentVue.
    public struct DentistInfo: XMLObjectDeserialization {
        /// Dentist name.
        public var name: String

        /// Dentist's office.
        public var office: String

        /// Dentist's phone number.
        public var phone: String

        /// Extension for the phone number.
        public var extn: String

        public static func deserialize(_ element: XMLIndexer) throws -> DentistInfo {
            DentistInfo(name: try element.value(ofAttribute: "Name"),
                        office: try element.value(ofAttribute: "Office"),
                        phone: try element.value(ofAttribute: "Phone"),
                        extn: try element.value(ofAttribute: "Extn"))
        }
    }

    /// Items defined for the student automatically.
    public struct UserDefinedItem: XMLObjectDeserialization {
        /// Name of the item.
        public var itemLabel: String

        /// Type of the item.
        public var itemType: String

        /// Unkown.
        public var sourceObject: String

        /// Unkown.
        public var sourceElement: String

        /// Unkown.
        public var vcid: String

        /// The value of the item.
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

    /// Information about the student. Some information is submitted by the parent
    /// while other information may be automatically assigned.
    public struct StudentInfo: XMLObjectDeserialization {
        /// Unkown.
        public var lockerInfoRecords: String? // TODO: Find data type

        /// Formatted full name of the student.
        public var formattedName: String

        /// Student school ID.
        public var permID: String

        /// Student gender.
        public var gender: String

        /// Current grade of the student.
        public var grade: String

        /// Home address of the student.
        public var address: String

        /// Unkown.
        public var lastNameGoesBy: String?

        /// Student nickname.
        public var nickname: String?

        /// Student birth date.
        public var birthDate: Date

        /// Student school email address.
        public var email: String

        /// Phone number provided by the parent.
        public var phone: String

        /// Spoken language at home.
        public var homeLanguage: String

        /// Name of the school currently attended by the student.
        public var currentSchool: String

        /// Unkown.
        public var track: String? // TODO: Find data type

        /// Student's home room teacher.
        public var homeRoomTeacher: String

        /// Email address of the home room teacher.
        public var homeRoomTeacherEmail: String

        /// GU of the home room teacher.
        public var homeRoomTeacherGU: String

        /// Unkown.
        public var orgYearGU: String

        /// Home room name in the school.
        public var homeRoom: String

        /// Name of the student's counselor.
        public var counselorName: String

        /// Photo of the student. Base64 string.
        public var photo: String?

        /// List of emergency contacts.
        public var emergencyContacts: [EmergencyContact]

        /// Physican information for the student.
        public var physicianInfo: PhysicianInfo

        /// Dentist information for the student.
        public var dentistInfo: DentistInfo

        /// Items automatically created for the student. Usually useful information.
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

extension StudentVueApi.EmergencyContact: Identifiable, Equatable {
    public var id: String {
        name + mobilePhone + homePhone
    }

    public static func == (lhs: StudentVueApi.EmergencyContact, rhs: StudentVueApi.EmergencyContact) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.PhysicianInfo: Identifiable, Equatable {
    public var id: String {
        name + phone
    }

    public static func == (lhs: StudentVueApi.PhysicianInfo, rhs: StudentVueApi.PhysicianInfo) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.DentistInfo: Identifiable, Equatable {
    public var id: String {
        name + phone
    }

    public static func == (lhs: StudentVueApi.DentistInfo, rhs: StudentVueApi.DentistInfo) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.UserDefinedItem: Identifiable, Equatable {
    public var id: String {
        vcid
    }

    public static func == (lhs: StudentVueApi.UserDefinedItem, rhs: StudentVueApi.UserDefinedItem) -> Bool {
        lhs.id == rhs.id
    }
}
