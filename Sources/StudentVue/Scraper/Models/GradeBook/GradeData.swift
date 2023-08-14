//
//  GradeData.swift
//
//
//  Created by TheMoonThatRises on 3/19/23.
//

import Foundation

extension StudentVueScraper {
    public struct GradeData: Decodable, Identifiable {
        enum CodingKeys: String, CodingKey {
            case teacher = "Teacher"
            case date = "Date"
            case gbAssignmentType = "GBAssignmentType"
            case gbResources = "GBResources"
            case gbSubject = "GBSubject"
            case gbScore = "GBScore"
            case gbScoreType = "GBScoreType"
            case gbPoints = "GBPoints"
            case gbNotes = "GBNotes"
            case gbDropBox = "GBDropBox"
            case gradeBookId, studentId, googleAssignmentLink
        }

        public var gradeBookId: String
        public var studentId: String
        public var teacher: String
        public var date: String
        public var googleAssignmentLink: String
        public var gbAssignmentType: String
        public var gbResources: String
        public var gbSubject: String
        public var gbScore: String
        public var gbScoreType: String
        public var gbPoints: String
        public var gbNotes: String
        public var gbDropBox: String

        public var id: String {
            gradeBookId
        }
    }
}
