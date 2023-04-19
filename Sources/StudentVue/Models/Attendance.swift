//
//  Attendance.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

struct AbsencePeriod: XMLObjectDeserialization {
    var period: Int
    var name: String
    var reason: String
    var course: String
    var teacher: String
    var teacherEmail: String
    var iconName: String
    var schoolName: String
    var teacherGU: String
    var orgYearGU: String

    static func deserialize(_ element: XMLIndexer) throws -> AbsencePeriod {
        AbsencePeriod(period: try element.value(ofAttribute: "Number"),
                      name: try element.value(ofAttribute: "Name"),
                      reason: try element.value(ofAttribute: "Reason"),
                      course: try element.value(ofAttribute: "Course"),
                      teacher: try element.value(ofAttribute: "Staff"),
                      teacherEmail: try element.value(ofAttribute: "StaffEMail"),
                      iconName: try element.value(ofAttribute: "IconName"),
                      schoolName: try element.value(ofAttribute: "SchoolName"),
                      teacherGU: try element.value(ofAttribute: "StaffGU"),
                      orgYearGU: try element.value(ofAttribute: "OrgYearGU"))
    }
}

struct Absence: XMLObjectDeserialization {
    var date: Date
    var reason: String
    var note: String
    var dailyIconName: String
    var codeAllDayReasonType: String
    var codeAllDayDescription: String
    var absencePeriods: [AbsencePeriod]

    static func deserialize(_ element: XMLIndexer) throws -> Absence {
        Absence(date: try element.value(ofAttribute: "AbsenceDate"),
                reason: try element.value(ofAttribute: "Reason"),
                note: try element.value(ofAttribute: "Note"),
                dailyIconName: try element.value(ofAttribute: "DailyIconName"),
                codeAllDayReasonType: try element.value(ofAttribute: "CodeAllDayReasonType"),
                codeAllDayDescription: try element.value(ofAttribute: "CodeAllDayDescription"),
                absencePeriods: try element["Periods"]["Period"].value())
    }
}

struct AttendancePeriodTotal: XMLObjectDeserialization {
    var period: Int
    var total: Int

    static func deserialize(_ element: XMLIndexer) throws -> AttendancePeriodTotal {
        AttendancePeriodTotal(period: try element.value(ofAttribute: "Number"),
                              total: try element.value(ofAttribute: "Total"))
    }
}

struct Attendance: XMLObjectDeserialization {
    var type: String // TODO: Find other types
    var startPeriod: Int
    var endPeriod: Int
    var periodCount: Int
    var schoolName: String
    var absences: [Absence]
    var totalExcused: [AttendancePeriodTotal]
    var totalTardies: [AttendancePeriodTotal]
    var totalUnexcused: [AttendancePeriodTotal]
    var totalActivities: [AttendancePeriodTotal]
    var totalUnexcusedTardies: [AttendancePeriodTotal]
    var concurrentSchoolsLists: String? // TODO: Find data type/structure

    static func deserialize(_ element: XMLIndexer) throws -> Attendance {
        let attendance = element["Attendance"]

        return Attendance(type: try attendance.value(ofAttribute: "Type"),
                          startPeriod: try attendance.value(ofAttribute: "StartPeriod"),
                          endPeriod: try attendance.value(ofAttribute: "EndPeriod"),
                          periodCount: try attendance.value(ofAttribute: "PeriodCount"),
                          schoolName: try attendance.value(ofAttribute: "SchoolName"),
                          absences: try attendance["Absences"].children.map { try $0.value() },
                          totalExcused: try attendance["TotalExcused"]["PeriodTotal"].value(),
                          totalTardies: try attendance["TotalTardies"]["PeriodTotal"].value(),
                          totalUnexcused: try attendance["TotalUnexcused"]["PeriodTotal"].value(),
                          totalActivities: try attendance["TotalActivities"]["PeriodTotal"].value(),
                          totalUnexcusedTardies: try attendance["TotalUnexcusedTardies"]["PeriodTotal"].value())
    }
}

extension Attendance {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
