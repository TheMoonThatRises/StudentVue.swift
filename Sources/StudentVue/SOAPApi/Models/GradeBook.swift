//
//  GradeBook.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/12/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct GradingPeriod: XMLObjectDeserialization {
        /// Index of the grading period.
        public var index: Int?

        /// Name of the grading period.
        public var gradePeriodName: String

        /// Start date of the grading period.
        public var startDate: Date

        /// End date of the grading period.
        public var endDate: Date

        public static func deserialize(_ element: XMLIndexer) throws -> GradingPeriod {
            GradingPeriod(index: element.value(ofAttribute: "Index"),
                          gradePeriodName: try element.value(ofAttribute: "GradePeriod"),
                          startDate: try element.value(ofAttribute: "StartDate"),
                          endDate: try element.value(ofAttribute: "EndDate"))
        }
    }

    /// Resource teacher provides with an assignment.
    public struct GradeBookResource: XMLObjectDeserialization {
        /// Class ID.
        public var classID: String

        /// Type of resource.
        public var fileType: String?

        /// Gradebook ID.
        public var gradebookID: String

        /// Date resource was created.
        public var resourceDate: Date

        /// Description of the resource.
        public var resourceDescription: String

        /// Resource ID.
        public var resourceID: String

        /// Name of the resource.
        public var resourceName: String

        /// Unkown.
        public var sequence: String

        /// Teacher ID.
        public var teacherID: String

        /// Unkown.
        public var type: String // TODO: Find other data types

        /// URL of the resource if provided.
        public var url: URL?

        /// Unkown.
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

    /// Assignment assigned by the teacher entered into the gradebook.
    public struct GradeBookAssignment: XMLObjectDeserialization {
        /// Assignment ID.
        public var gradeBookID: String

        /// Name of the assignment.
        public var measure: String

        /// Assignment type (e.x. participation, test).
        public var type: String

        /// Assignment date.
        public var date: Date

        /// Due date of the assignment.
        public var dueDate: Date

        /// Type of score.
        public var scoreType: String

        /// Points recieved.
        public var points: String

        /// Total seconds since the assignment was posted.
        public var totalSecondsSincePost: Double

        /// Unkown.
        public var notes: String

        /// Student ID.
        public var teacherID: String

        /// Teacher ID.
        public var studentID: String

        /// Description of the assignment.
        public var measureDescription: String

        /// If the assignment has a Drop Box.
        public var hasDropBox: Bool

        /// Unkown.
        public var dropStartDate: Date

        /// Unkown.
        public var dropEndDate: Date

        /// A list of resources the teacher provides with the assignment.
        public var resources: [GradeBookResource]

        public static func deserialize(_ element: XMLIndexer) throws -> GradeBookAssignment {
            GradeBookAssignment(gradeBookID: try element.value(ofAttribute: "GradebookID"),
                                measure: try element.value(ofAttribute: "Measure"),
                                type: try element.value(ofAttribute: "Type"),
                                date: try element.value(ofAttribute: "Date"),
                                dueDate: try element.value(ofAttribute: "DueDate"),
                                scoreType: try element.value(ofAttribute: "ScoreType"),
                                points: try element.value(ofAttribute: "Points"),
                                totalSecondsSincePost: try element.value(ofAttribute: "TotalSecondsSincePost"),
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

    /// Grading period assignments and grade.
    public struct Grade: XMLObjectDeserialization {
        /// Name of the grading period.
        public var gradePeriodName: String

        /// Letter grade when calculated.
        public var calculatedGrade: String

        /// Raw grade recieved.
        public var calculatedGradeRaw: Float

        /// List of assignments in the grading period.
        public var assignments: [GradeBookAssignment]

        public static func deserialize(_ element: XMLIndexer) throws -> Grade {
            Grade(gradePeriodName: try element.value(ofAttribute: "MarkName"),
                  calculatedGrade: try element.value(ofAttribute: "CalculatedScoreString"),
                  calculatedGradeRaw: try element.value(ofAttribute: "CalculatedScoreRaw"),
                  assignments: try element["Assignments"].children.map { try $0.value() })
        }
    }

    /// Course taken by the student in the gradebook.
    public struct Course: XMLObjectDeserialization {
        /// Unkown.
        public var usesRichContent: Bool

        /// Period of the class.
        public var period: Int

        /// Name of the class.
        public var name: String

        /// Room name in the school.
        public var room: String

        /// Name of the teacher.
        public var teacher: String

        /// Teacher email for the course.
        public var teacherEmail: String

        /// GU of the teacher.
        public var teacherGU: String

        /// Cut-off bar for when the grade should be highlighted(?).
        public var highlightPercentageCutOffForProgressBar: Int

        /// List of grades throughout grading periods in the course.
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

    /// Gradebook for the student.
    public struct GradeBook: XMLObjectDeserialization {
        /// List of available grading periods.
        public var gradingPeriods: [GradingPeriod]

        /// Current grading period.
        public var cuarrentGradingPeriod: GradingPeriod

        /// List of courses taken by the student with their grades.
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

extension StudentVueApi.GradeBookResource: Identifiable, Equatable {
    public var id: String {
        resourceID
    }

    public static func == (lhs: StudentVueApi.GradeBookResource, rhs: StudentVueApi.GradeBookResource) -> Bool {
        lhs.id == rhs.id
    }
}

extension StudentVueApi.GradeBookAssignment: Identifiable, Equatable {
    public var id: String {
        gradeBookID
    }

    public static func == (lhs: StudentVueApi.GradeBookAssignment, rhs: StudentVueApi.GradeBookAssignment) -> Bool {
        lhs.id == rhs.id
    }
}
