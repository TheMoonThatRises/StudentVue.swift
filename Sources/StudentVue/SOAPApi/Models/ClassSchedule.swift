//
//  ClassSchedule.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct ClassScheduleInfo: XMLObjectDeserialization {
        public var period: String
        public var className: String
        public var classURL: String
        public var startTime: Date
        public var endTime: Date
        public var teacherName: String
        public var teacherURL: String
        public var roomName: String
        public var teacherEmail: String
        public var emailSubject: String
        public var teacherGU: String
        public var startDate: Date
        public var endDate: Date
        public var sectionGU: String
        public var hideClassStartEndTime: Bool
        public var attendanceCode: String? // TODO: Find data type/structure

        public static func deserialize(_ element: XMLIndexer) throws -> ClassScheduleInfo {
            ClassScheduleInfo(period: try element.value(ofAttribute: "Period"),
                              className: try element.value(ofAttribute: "ClassName"),
                              classURL: try element.value(ofAttribute: "ClassURL"),
                              startTime: try element.value(ofAttribute: "StartTime"),
                              endTime: try element.value(ofAttribute: "EndTime"),
                              teacherName: try element.value(ofAttribute: "TeacherName"),
                              teacherURL: try element.value(ofAttribute: "TeacherURL"),
                              roomName: try element.value(ofAttribute: "RoomName"),
                              teacherEmail: try element.value(ofAttribute: "TeacherEmail"),
                              emailSubject: try element.value(ofAttribute: "EmailSubject"),
                              teacherGU: try element.value(ofAttribute: "StaffGU"),
                              startDate: try element.value(ofAttribute: "StartDate"),
                              endDate: try element.value(ofAttribute: "EndDate"),
                              sectionGU: try element.value(ofAttribute: "SectionGU"),
                              hideClassStartEndTime: try element.value(ofAttribute: "HideClassStartEndTime"))
        }
    }

    public struct SchoolScheduleInfo: XMLObjectDeserialization {
        public var schoolName: String
        public var bellScheduleName: String
        public var classes: [ClassScheduleInfo]

        public static func deserialize(_ element: XMLIndexer) throws -> SchoolScheduleInfo {
            SchoolScheduleInfo(schoolName: try element.value(ofAttribute: "SchoolName"),
                               bellScheduleName: try element.value(ofAttribute: "BellSchedName"),
                               classes: try element["Classes"]["ClassInfo"].value())
        }
    }

    public struct TodayScheduleInfo: XMLObjectDeserialization {
        public var date: Date
        public var schoolInfos: [SchoolScheduleInfo]

        public static func deserialize(_ element: XMLIndexer) throws -> TodayScheduleInfo {
            TodayScheduleInfo(date: try element.value(ofAttribute: "Date"),
                              schoolInfos: try element["SchoolInfos"]["SchoolInfo"].value())
        }
    }

    public struct ClassListSchedule: XMLObjectDeserialization {
        public var period: Int
        public var courseTitle: String
        public var roomName: String
        public var teacher: String
        public var teacherEmail: String
        public var sectionGU: String
        public var teacherGU: String
        public var additionalStaffInformation: [String]? // TODO: Find data type/structure

        public static func deserialize(_ element: XMLIndexer) throws -> ClassListSchedule {
            ClassListSchedule(period: try element.value(ofAttribute: "Period"),
                              courseTitle: try element.value(ofAttribute: "CourseTitle"),
                              roomName: try element.value(ofAttribute: "RoomName"),
                              teacher: try element.value(ofAttribute: "Teacher"),
                              teacherEmail: try element.value(ofAttribute: "TeacherEmail"),
                              sectionGU: try element.value(ofAttribute: "SectionGU"),
                              teacherGU: try element.value(ofAttribute: "TeacherStaffGU"))
        }
    }

    public struct TermDefCodesSchedule: XMLObjectDeserialization {
        public var termDefName: String

        public static func deserialize(_ element: XMLIndexer) throws -> TermDefCodesSchedule {
            TermDefCodesSchedule(termDefName: try element.value(ofAttribute: "TermDefName"))
        }
    }

    public struct TermListSchedule: XMLObjectDeserialization {
        public var termIndex: Int
        public var termCode: Int
        public var termName: String
        public var beginDate: Date
        public var endDate: Date
        public var schoolYearTermCodeGU: String
        public var termDefCodes: [TermDefCodesSchedule]

        public static func deserialize(_ element: XMLIndexer) throws -> TermListSchedule {
            TermListSchedule(termIndex: try element.value(ofAttribute: "TermIndex"),
                             termCode: try element.value(ofAttribute: "TermCode"),
                             termName: try element.value(ofAttribute: "TermName"),
                             beginDate: try element.value(ofAttribute: "BeginDate"),
                             endDate: try element.value(ofAttribute: "EndDate"),
                             schoolYearTermCodeGU: try element.value(ofAttribute: "SchoolYearTrmCodeGU"),
                             termDefCodes: try element["TermDefCodes"]["TermDefCode"].value())
        }
    }

    public struct ClassSchedule: XMLObjectDeserialization {
        public var termIndex: Int
        public var termIndexName: String
        public var errorMessage: String
        public var includeAdditionaWhenEmailingTeachers: Bool
        public var todayScheduleInfo: TodayScheduleInfo?
        public var classLists: [ClassListSchedule]
        public var termLists: [TermListSchedule]
        public var concurrentSchoolStudentClassSchedules: [String]? // TODO: Find data type/structure

        public static func deserialize(_ element: XMLIndexer) throws -> ClassSchedule {
            let schedule = element["StudentClassSchedule"]

            return ClassSchedule(termIndex: try schedule.value(ofAttribute: "TermIndex"),
                                 termIndexName: try schedule.value(ofAttribute: "TermIndexName"),
                                 errorMessage: try schedule.value(ofAttribute: "ErrorMessage"),
                                 includeAdditionaWhenEmailingTeachers: try schedule.value(ofAttribute: "IncludeAdditionalStaffWhenEmailingTeachers"),
                                 todayScheduleInfo: try? schedule["TodayScheduleInfoData"].value(),
                                 classLists: try schedule["ClassLists"]["ClassListing"].value(),
                                 termLists: try schedule["TermLists"]["TermListing"].value())
        }
    }
}

extension StudentVueApi.ClassSchedule {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
