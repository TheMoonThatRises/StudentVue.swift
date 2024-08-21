//
//  Attendance.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct AbsencePeriod: XMLObjectDeserialization {
        /// The period the student was absent.
        public var period: Int

        /// Unknown.
        public var name: String

        /// The reason the student was absent.
        public var reason: String

        /// The course the student was absent from.
        public var course: String

        /// The teacher of the class the student was absent from.
        public var teacher: String

        /// The email of the teacher.
        public var teacherEmail: String

        /// Unknown.
        public var iconName: String

        /// The name of the school.
        public var schoolName: String

        /// The GU of the teacher of the class.
        public var teacherGU: String

        /// The GU year the absence occured.
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
        /// The date of the absence.
        public var date: Date

        /// The reason of the absence.
        public var reason: String

        /// The note of the absence.
        public var note: String

        /// Unkown.
        public var dailyIconName: String

        /// Unknown.
        public var codeAllDayReasonType: String

        /// Unknown.
        public var codeAllDayDescription: String

        /// List of periods the student was absent from.
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

    public struct ConcurrentSchoolsList: XMLObjectDeserialization {
        /// Name of the school the student is going to in addition to their primary school.
        public var concurrentSchoolName: String

        /// GU of the year for the concurrent school.
        public var concurrentOrgYearGU: String

        public static func deserialize(_ element: XMLIndexer) throws -> ConcurrentSchoolsList {
            ConcurrentSchoolsList(concurrentSchoolName: try element.value(ofAttribute: "ConcurrentSchoolName"),
                                  concurrentOrgYearGU: try element.value(ofAttribute: "ConcurrentOrgYearGU"))
        }
    }

    public struct Attendance: XMLObjectDeserialization {
        /// Unkown.
        public var type: String

        /// Unknown.
        public var startPeriod: Int

        /// Unkown.
        public var endPeriod: Int

        /// Unkown.
        public var periodCount: Int

        /// Name of the school.
        public var schoolName: String

        /// List of all absences.
        public var absences: [Absence]

        /// List of excused absences.
        public var totalExcused: [AttendancePeriodTotal]

        /// List of tardies.
        public var totalTardies: [AttendancePeriodTotal]

        /// List of unexcused absences.
        public var totalUnexcused: [AttendancePeriodTotal]

        /// List of excused absences due to an activity.
        public var totalActivities: [AttendancePeriodTotal]

        /// List of unexcused tardies.
        public var totalUnexcusedTardies: [AttendancePeriodTotal]

        /// List of schools the student is concurrently attending.
        public var concurrentSchoolsLists: [ConcurrentSchoolsList]

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
                              totalUnexcusedTardies: try attendance["TotalUnexcusedTardies"]["PeriodTotal"].value(),
                              concurrentSchoolsLists: try attendance["ConcurrentSchoolsLists"]["ConcurrentSchoolsList"].value())
        }
    }
}

extension StudentVueApi.Attendance {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
