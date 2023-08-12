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
        var index: Int?
        var gradePeriodName: String
        var startDate: Date
        var endDate: Date

        public static func deserialize(_ element: XMLIndexer) throws -> GradingPeriod {
            GradingPeriod(index: element.value(ofAttribute: "Index"),
                          gradePeriodName: try element.value(ofAttribute: "GradePeriod"),
                          startDate: try element.value(ofAttribute: "StartDate"),
                          endDate: try element.value(ofAttribute: "EndDate"))
        }
    }

    public struct GradeBookResource: XMLObjectDeserialization {
        var classID: String
        var fileType: String?
        var gradebookID: String
        var resourceDate: Date
        var resourceDescription: String
        var resourceID: String
        var resourceName: String
        var sequence: String
        var teacherID: String
        var type: String // TODO: Find other data types

        var url: URL?
        var serverFileName: String

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
        var gradeBookID: String
        var measure: String
        var type: String
        var date: Date
        var dueDate: Date
        var score: String
        var scoreType: String
        var points: String
        var notes: String
        var teacherID: String
        var studentID: String
        var measureDescription: String
        var hasDropBox: Bool
        var dropStartDate: Date
        var dropEndDate: Date
        var resources: [GradeBookResource]

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
        var gradePeriodName: String
        var calculatedGrade: String
        var calculatedGradeRaw: Float
        var assignments: [GradeBookAssignment]

        public static func deserialize(_ element: XMLIndexer) throws -> Grade {
            Grade(gradePeriodName: try element.value(ofAttribute: "MarkName"),
                  calculatedGrade: try element.value(ofAttribute: "CalculatedScoreString"),
                  calculatedGradeRaw: try element.value(ofAttribute: "CalculatedScoreRaw"),
                  assignments: try element["Assignments"].children.map { try $0.value() })
        }
    }

    public struct Course: XMLObjectDeserialization {
        var usesRichContent: Bool
        var period: Int
        var name: String
        var room: String
        var teacher: String
        var teacherEmail: String
        var teacherGU: String
        var highlightPercentageCutOffForProgressBar: Int
        var grades: [Grade]

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
        var gradingPeriods: [GradingPeriod]
        var cuarrentGradingPeriod: GradingPeriod
        var courses: [Course]

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
