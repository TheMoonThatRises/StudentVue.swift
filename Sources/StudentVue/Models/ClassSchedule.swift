//
//  ClassSchedule.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

struct ClassScheduleInfo: XMLObjectDeserialization {
    var period: String
    var className: String
    var classURL: String
    var startTime: Date
    var endTime: Date
    var teacherName: String
    var teacherURL: String
    var roomName: String
    var teacherEmail: String
    var emailSubject: String
    var teacherGU: String
    var startDate: Date
    var endDate: Date
    var sectionGU: String
    var hideClassStartEndTime: Bool
    var attendanceCode: String? // TODO: Find data type/structure

    static func deserialize(_ element: XMLIndexer) throws -> ClassScheduleInfo {
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

struct SchoolScheduleInfo: XMLObjectDeserialization {
    var schoolName: String
    var bellScheduleName: String
    var classes: [ClassScheduleInfo]

    static func deserialize(_ element: XMLIndexer) throws -> SchoolScheduleInfo {
        SchoolScheduleInfo(schoolName: try element.value(ofAttribute: "SchoolName"),
                           bellScheduleName: try element.value(ofAttribute: "BellSchedName"),
                           classes: try element["Classes"]["ClassInfo"].value())
    }
}

struct TodayScheduleInfo: XMLObjectDeserialization {
    var date: Date
    var schoolInfos: [SchoolScheduleInfo]

    static func deserialize(_ element: XMLIndexer) throws -> TodayScheduleInfo {
        TodayScheduleInfo(date: try element.value(ofAttribute: "Date"),
                          schoolInfos: try element["SchoolInfos"]["SchoolInfo"].value())
    }
}

struct ClassListSchedule: XMLObjectDeserialization {
    var period: Int
    var courseTitle: String
    var roomName: String
    var teacher: String
    var teacherEmail: String
    var sectionGU: String
    var teacherGU: String
    var additionalStaffInformation: [String]? // TODO: Find data type/structure

    static func deserialize(_ element: XMLIndexer) throws -> ClassListSchedule {
        ClassListSchedule(period: try element.value(ofAttribute: "Period"),
                          courseTitle: try element.value(ofAttribute: "CourseTitle"),
                          roomName: try element.value(ofAttribute: "RoomName"),
                          teacher: try element.value(ofAttribute: "Teacher"),
                          teacherEmail: try element.value(ofAttribute: "TeacherEmail"),
                          sectionGU: try element.value(ofAttribute: "SectionGU"),
                          teacherGU: try element.value(ofAttribute: "TeacherStaffGU"))
    }
}

struct TermDefCodesSchedule: XMLObjectDeserialization {
    var termDefName: String

    static func deserialize(_ element: XMLIndexer) throws -> TermDefCodesSchedule {
        TermDefCodesSchedule(termDefName: try element.value(ofAttribute: "TermDefName"))
    }
}

struct TermListSchedule: XMLObjectDeserialization {
    var termIndex: Int
    var termCode: Int
    var termName: String
    var beginDate: Date
    var endDate: Date
    var schoolYearTermCodeGU: String
    var termDefCodes: [TermDefCodesSchedule]

    static func deserialize(_ element: XMLIndexer) throws -> TermListSchedule {
        TermListSchedule(termIndex: try element.value(ofAttribute: "TermIndex"),
                         termCode: try element.value(ofAttribute: "TermCode"),
                         termName: try element.value(ofAttribute: "TermName"),
                         beginDate: try element.value(ofAttribute: "BeginDate"),
                         endDate: try element.value(ofAttribute: "EndDate"),
                         schoolYearTermCodeGU: try element.value(ofAttribute: "SchoolYearTrmCodeGU"),
                         termDefCodes: try element["TermDefCodes"]["TermDefCode"].value())
    }
}

struct ClassSchedule: XMLObjectDeserialization {
    var termIndex: Int
    var termIndexName: String
    var errorMessage: String
    var includeAdditionaWhenEmailingTeachers: Bool
    var todayScheduleInfo: TodayScheduleInfo?
    var classLists: [ClassListSchedule]
    var termLists: [TermListSchedule]
    var concurrentSchoolStudentClassSchedules: [String]? // TODO: Find data type/structure

    static func deserialize(_ element: XMLIndexer) throws -> ClassSchedule {
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

extension ClassSchedule {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
