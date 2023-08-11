//
//  GradeData.swift
//  
//
//  Created by TheMoonThatRises on 3/19/23.
//

import Foundation

struct GradeData: Decodable, Identifiable {
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

    var gradeBookId: String
    var studentId: String
    var teacher: String
    var date: String
    var googleAssignmentLink: String
    var gbAssignmentType: String
    var gbResources: String
    var gbSubject: String
    var gbScore: String
    var gbScoreType: String
    var gbPoints: String
    var gbNotes: String
    var gbDropBox: String

    var id: String {
        gradeBookId
    }
}
