//
//  GradeBook.swift
//  
//
//  Created by TheMoonThatRises on 4/12/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct GradingPeriod: XMLObjectDeserialization {
        public var index: Int?
        public var gradePeriodName: String
        public var startDate: Date
        public var endDate: Date

        public static func deserialize(_ element: XMLIndexer) throws -> GradingPeriod {
            GradingPeriod(index: element.value(ofAttribute: "Index"),
                          gradePeriodName: try element.value(ofAttribute: "GradePeriod"),
                          startDate: try element.value(ofAttribute: "StartDate"),
                          endDate: try element.value(ofAttribute: "EndDate"))
        }
    }

    public struct GradeBookResource: XMLObjectDeserialization {
        public var classID: String
        public var fileType: String?
        public var gradebookID: String
        public var resourceDate: Date
        public var resourceDescription: String
        public var resourceID: String
        public var resourceName: String
        public var sequence: String
        public var teacherID: String
        public var type: String // TODO: Find other data types

        public var url: URL?
        public var serverFileName: String

        public static func deserialize(_ element: XMLIndexer) throws -> GradeBookResource {
            GradeBookResource(classID: try element.value(ofAttribute: "ClassID"),
                              fileType: element.value(ofAttribute: "FileType"),
                              gradebookID: try element.value(ofAttribute: "GradebookID"),
                              resourceDate: try element.value(ofAttribute: "ResourceDate"),
                              resourceDescription: try element.value(ofAttribute: "ResourceDescription"),
                              resourceID: try element.value(ofAttribute: "ResourceID"),
                              resourceName: try element.value(ofAttribute: "ResourceName"),
                              sequence: try element.value(ofAttribute: "Sequence"),
                              teacherID: try element.value(ofAttribute: "TeacherID"),
                              type: try element.value(ofAttribute: "Type"),
                              url: URL(string: element.value(ofAttribute: "URL") ?? ""),
                              serverFileName: try element.value(ofAttribute: "ServerFileName"))
        }
    }

    public struct GradeBookAssignment: XMLObjectDeserialization {
        public var gradeBookID: String
        public var measure: String
        public var type: String
        public var date: Date
        public var dueDate: Date
        public var score: String
        public var scoreType: String
        public var points: String
        public var notes: String
        public var teacherID: String
        public var studentID: String
        public var measureDescription: String
        public var hasDropBox: Bool
        public var dropStartDate: Date
        public var dropEndDate: Date
        public var resources: [GradeBookResource]

        public static func deserialize(_ element: XMLIndexer) throws -> GradeBookAssignment {
            GradeBookAssignment(gradeBookID: try element.value(ofAttribute: "GradebookID"),
                                measure: try element.value(ofAttribute: "Measure"),
                                type: try element.value(ofAttribute: "Type"),
                                date: try element.value(ofAttribute: "Date"),
                                dueDate: try element.value(ofAttribute: "DueDate"),
                                score: try element.value(ofAttribute: "Score"),
                                scoreType: try element.value(ofAttribute: "ScoreType"),
                                points: try element.value(ofAttribute: "Points"),
                                notes: try element.value(ofAttribute: "Notes"),
                                teacherID: try element.value(ofAttribute: "TeacherID"),
                                studentID: try element.value(ofAttribute: "StudentID"),
                                measureDescription: try element.value(ofAttribute: "MeasureDescription"),
                                hasDropBox: try element.value(ofAttribute: "HasDropBox"),
                                dropStartDate: try element.value(ofAttribute: "DropStartDate"),
                                dropEndDate: try element.value(ofAttribute: "DropEndDate"),
                                resources: try element["Resources"].children.map { try $0.value() })
        }
    }

    public struct Grade: XMLObjectDeserialization {
        public var gradePeriodName: String
        public var calculatedGrade: String
        public var calculatedGradeRaw: Float
        public var assignments: [GradeBookAssignment]

        public static func deserialize(_ element: XMLIndexer) throws -> Grade {
            Grade(gradePeriodName: try element.value(ofAttribute: "MarkName"),
                  calculatedGrade: try element.value(ofAttribute: "CalculatedScoreString"),
                  calculatedGradeRaw: try element.value(ofAttribute: "CalculatedScoreRaw"),
                  assignments: try element["Assignments"].children.map { try $0.value() })
        }
    }

    public struct Course: XMLObjectDeserialization {
        public var usesRichContent: Bool
        public var period: Int
        public var name: String
        public var room: String
        public var teacher: String
        public var teacherEmail: String
        public var teacherGU: String
        public var highlightPercentageCutOffForProgressBar: Int
        public var grades: [Grade]

        public static func deserialize(_ element: XMLIndexer) throws -> Course {
            Course(usesRichContent: try element.value(ofAttribute: "UsesRichContent"),
                   period: try element.value(ofAttribute: "Period"),
                   name: try element.value(ofAttribute: "Title"),
                   room: try element.value(ofAttribute: "Room"),
                   teacher: try element.value(ofAttribute: "Staff"),
                   teacherEmail: try element.value(ofAttribute: "StaffEMail"),
                   teacherGU: try element.value(ofAttribute: "StaffGU"),
                   highlightPercentageCutOffForProgressBar: try element.value(ofAttribute: "HighlightPercentageCutOffForProgressBar"),
                   grades: try element["Marks"]["Mark"].value())
        }
    }

    public struct GradeBook: XMLObjectDeserialization {
        public var gradingPeriods: [GradingPeriod]
        public var cuarrentGradingPeriod: GradingPeriod
        public var courses: [Course]

        public static func deserialize(_ element: XMLIndexer) throws -> GradeBook {
            let gradebook = element["Gradebook"]

            return try GradeBook(gradingPeriods: gradebook["ReportingPeriods"]["ReportPeriod"].value(),
                                 cuarrentGradingPeriod: gradebook["ReportingPeriod"].value(),
                                 courses: gradebook["Courses"]["Course"].value())
        }
    }
}

extension StudentVueApi.GradeBook {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
