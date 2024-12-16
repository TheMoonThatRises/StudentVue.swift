//
//  ClassSchedule.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct ClassScheduleInfo: XMLObjectDeserialization {
        /// Class period.
        public var period: String

        /// Name of the class.
        public var className: String

        /// URL for the class provided by the teacher (or when linked to Google Classroom).
        public var classURL: String

        /// The start time of the class.
        public var startTime: Date

        /// The end time of the class.
        public var endTime: Date

        /// Name of the teacher.
        public var teacherName: String

        /// Unkown.
        public var teacherURL: String

        /// The room name in the school.
        public var roomName: String

        /// The email of the teacher.
        public var teacherEmail: String

        /// Unkown.
        public var emailSubject: String

        /// The GU of the teacher.
        public var teacherGU: String

        /// Unkown.
        public var startDate: Date

        /// Unkown.
        public var endDate: Date

        /// Unkown.
        public var sectionGU: String

        /// Unkown.
        public var hideClassStartEndTime: Bool

        /// Unkown.
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
        /// Name of the school.
        public var schoolName: String

        /// Name of the bell schedule.
        public var bellScheduleName: String

        /// List of classes the student is taking.
        public var classes: [ClassScheduleInfo]

        public static func deserialize(_ element: XMLIndexer) throws -> SchoolScheduleInfo {
            SchoolScheduleInfo(schoolName: try element.value(ofAttribute: "SchoolName"),
                               bellScheduleName: try element.value(ofAttribute: "BellSchedName"),
                               classes: try element["Classes"]["ClassInfo"].value())
        }
    }

    public struct TodayScheduleInfo: XMLObjectDeserialization {
        /// Current date.
        public var date: Date

        /// List of classes the student is taking today.
        public var schoolInfos: [SchoolScheduleInfo]

        public static func deserialize(_ element: XMLIndexer) throws -> TodayScheduleInfo {
            TodayScheduleInfo(date: try element.value(ofAttribute: "Date"),
                              schoolInfos: try element["SchoolInfos"]["SchoolInfo"].value())
        }
    }

    public struct AdditionalStaffInformationXML: XMLObjectDeserialization {

    }

    public struct ClassListSchedule: XMLObjectDeserialization {
        /// Class period.
        public var period: Int

        /// Title of the class.
        public var courseTitle: String

        /// Room name in the school.
        public var roomName: String

        /// The teacher of the class.
        public var teacher: String

        /// The email of the teacher.
        public var teacherEmail: String

        /// Unkown.
        public var sectionGU: String

        /// The GU of the teacher.
        public var teacherGU: String

        /// Unkown.
        public var additionalStaffInformationXMLs: [AdditionalStaffInformationXML]?

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
        /// The term name (e.x. `S1`, `S2`, `YR`).
        public var termDefName: String

        public static func deserialize(_ element: XMLIndexer) throws -> TermDefCodesSchedule {
            TermDefCodesSchedule(termDefName: try element.value(ofAttribute: "TermDefName"))
        }
    }

    public struct TermListSchedule: XMLObjectDeserialization {
        /// Current term.
        public var termIndex: Int

        /// ``termIndex`` + 1.
        public var termCode: Int

        /// Name of the current term.
        public var termName: String

        /// Begin date of the term.
        public var beginDate: Date

        /// End date of the term.
        public var endDate: Date

        /// GU code for the school's year term.
        public var schoolYearTermCodeGU: String

        /// List of term definitions.
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

    public struct ClassListing: XMLObjectDeserialization {
        /// The email of the teacher.
        public var teacherEmail: String

        /// Unkown.
        public var excludePVUE: Bool

        /// Name of the teacher.
        public var teacher: String

        /// Period of the class.
        public var period: Int

        /// Name of the class.
        public var courseTitle: String

        /// GU of the teacher.
        public var teacherStaffGU: String

        /// Unkown.
        public var sectionGU: String

        /// Room name in the school.
        public var roomName: String

        /// Unkown.
        public var additionalStaffInformationXMLs: [AdditionalStaffInformationXML]?

        public static func deserialize(_ element: XMLIndexer) throws -> ClassListing {
            ClassListing(teacherEmail: try element.value(ofAttribute: "TeacherEmail"),
                         excludePVUE: try element.value(ofAttribute: "ExcludePVUE"),
                         teacher: try element.value(ofAttribute: "Teacher"),
                         period: try element.value(ofAttribute: "Period"),
                         courseTitle: try element.value(ofAttribute: "CourseTitle"),
                         teacherStaffGU: try element.value(ofAttribute: "TeacherStaffGU"),
                         sectionGU: try element.value(ofAttribute: "SectionGU"),
                         roomName: try element.value(ofAttribute: "RoomName"))
        }
    }

    public struct ConcurrentSchoolStudentClassSchedule: XMLObjectDeserialization {
        /// Term index name.
        public var conSchTermIndexName: String

        /// Unkown.
        public var conSchOrgYearGU: String

        /// Term index.
        public var conSchTermIndex: Int

        /// Name of the concurrent school.
        public var schoolName: String

        /// Error message.
        public var conSchErrorMessage: String

        /// List of classes the student is taking at the concurrent school.
        public var conSchClassLists: [ClassListing]

        public static func deserialize(_ element: XMLIndexer) throws -> ConcurrentSchoolStudentClassSchedule {
            ConcurrentSchoolStudentClassSchedule(conSchTermIndexName: try element.value(ofAttribute: "ConSchTermIndexName"),
                                                 conSchOrgYearGU: try element.value(ofAttribute: "ConSchOrgYearGU"),
                                                 conSchTermIndex: try element.value(ofAttribute: "ConSchTermIndex"),
                                                 schoolName: try element.value(ofAttribute: "SchoolName"),
                                                 conSchErrorMessage: try element.value(ofAttribute: "ConSchErrorMessage"),
                                                 conSchClassLists: try element["ConSchClassLists"]["ClassListing"].value())
        }
    }

    public struct ClassSchedule: XMLObjectDeserialization {
        /// Current term index.
        public var termIndex: Int

        /// Current term index name.
        public var termIndexName: String

        /// Error message.
        public var errorMessage: String

        /// Unkown.
        public var includeAdditionalWhenEmailingTeachers: Bool

        /// Today's schedule. `nil` when today is not a school day.
        public var todayScheduleInfo: TodayScheduleInfo?

        /// List of classes taken by the student.
        public var classLists: [ClassListSchedule]

        /// List of terms.
        public var termLists: [TermListSchedule]

        /// Schedule of the student if they are attending multiple schools.
        public var concurrentSchoolStudentClassSchedules: [ConcurrentSchoolStudentClassSchedule]

        public static func deserialize(_ element: XMLIndexer) throws -> ClassSchedule {
            let schedule = element["StudentClassSchedule"]

            return ClassSchedule(termIndex: try schedule.value(ofAttribute: "TermIndex"),
                                 termIndexName: try schedule.value(ofAttribute: "TermIndexName"),
                                 errorMessage: try schedule.value(ofAttribute: "ErrorMessage"),
                                 includeAdditionalWhenEmailingTeachers: try schedule.value(ofAttribute: "IncludeAdditionalStaffWhenEmailingTeachers"),
                                 todayScheduleInfo: try? schedule["TodayScheduleInfoData"].value(),
                                 classLists: try schedule["ClassLists"]["ClassListing"].value(),
                                 termLists: try schedule["TermLists"]["TermListing"].value(),
                                 concurrentSchoolStudentClassSchedules:
                                    try schedule["ConcurrentSchoolStudentClassSchedules"]["ConcurrentSchoolStudentClassSchedule"].value())
        }
    }
}

extension StudentVueApi.ClassSchedule {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}

extension StudentVueApi.ClassScheduleInfo: Identifiable, Equatable {
    public var id: String {
        sectionGU
    }

    public static func == (lhs: StudentVueApi.ClassScheduleInfo, rhs: StudentVueApi.ClassScheduleInfo) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.SchoolScheduleInfo: Identifiable, Equatable {
    public var id: String {
        schoolName + bellScheduleName
    }

    public static func == (lhs: StudentVueApi.SchoolScheduleInfo, rhs: StudentVueApi.SchoolScheduleInfo) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.ClassListSchedule: Identifiable, Equatable {
    public var id: String {
        sectionGU
    }

    public static func == (lhs: StudentVueApi.ClassListSchedule, rhs: StudentVueApi.ClassListSchedule) -> Bool {
        lhs.id == rhs.id
    }
}
