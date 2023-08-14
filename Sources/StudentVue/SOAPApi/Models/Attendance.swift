//
//  Attendance.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct AbsencePeriod: XMLObjectDeserialization {
        public var period: Int
        public var name: String
        public var reason: String
        public var course: String
        public var teacher: String
        public var teacherEmail: String
        public var iconName: String
        public var schoolName: String
        public var teacherGU: String
        public var orgYearGU: String

        public static func deserialize(_ element: XMLIndexer) throws -> AbsencePeriod {
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

    public struct Absence: XMLObjectDeserialization {
        public var date: Date
        public var reason: String
        public var note: String
        public var dailyIconName: String
        public var codeAllDayReasonType: String
        public var codeAllDayDescription: String
        public var absencePeriods: [AbsencePeriod]

        public static func deserialize(_ element: XMLIndexer) throws -> Absence {
            Absence(date: try element.value(ofAttribute: "AbsenceDate"),
                    reason: try element.value(ofAttribute: "Reason"),
                    note: try element.value(ofAttribute: "Note"),
                    dailyIconName: try element.value(ofAttribute: "DailyIconName"),
                    codeAllDayReasonType: try element.value(ofAttribute: "CodeAllDayReasonType"),
                    codeAllDayDescription: try element.value(ofAttribute: "CodeAllDayDescription"),
                    absencePeriods: try element["Periods"]["Period"].value())
        }
    }

    public struct AttendancePeriodTotal: XMLObjectDeserialization {
        public var period: Int
        public var total: Int

        public static func deserialize(_ element: XMLIndexer) throws -> AttendancePeriodTotal {
            AttendancePeriodTotal(period: try element.value(ofAttribute: "Number"),
                                  total: try element.value(ofAttribute: "Total"))
        }
    }

    public struct Attendance: XMLObjectDeserialization {
        public var type: String // TODO: Find other types
        public var startPeriod: Int
        public var endPeriod: Int
        public var periodCount: Int
        public var schoolName: String
        public var absences: [Absence]
        public var totalExcused: [AttendancePeriodTotal]
        public var totalTardies: [AttendancePeriodTotal]
        public var totalUnexcused: [AttendancePeriodTotal]
        public var totalActivities: [AttendancePeriodTotal]
        public var totalUnexcusedTardies: [AttendancePeriodTotal]
        public var concurrentSchoolsLists: String? // TODO: Find data type/structure

        public static func deserialize(_ element: XMLIndexer) throws -> Attendance {
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
}

extension StudentVueApi.Attendance {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
