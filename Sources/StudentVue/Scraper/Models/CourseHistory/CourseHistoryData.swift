//
//  CourseHistoryData.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/18/24.
//

import Foundation

extension StudentVueScraper {
    public struct CourseData: Decodable, Identifiable {
        enum CodingKeys: String, CodingKey {
            case courseID = "CourseID"
            case courseTitle = "CourseTitle"
            case creditsAttempted = "CreditsAttempted"
            case creditsCompleted = "CreditsCompleted"
            case verifiedCredit = "VerifiedCredit"
            case mark = "Mark"
            case chsType = "CHSType"
        }

        public var courseID: String
        public var courseTitle: String
        public var creditsAttempted: String
        public var creditsCompleted: String
        public var verifiedCredit: String
        public var mark: String
        public var chsType: String

        public var id: String {
            courseID
        }
    }

    public struct CourseHistoryTerm: Decodable, Identifiable {
        enum CodingKeys: String, CodingKey {
            case schoolName = "SchoolName"
            case year = "Year"
            case termName = "TermName"
            case termOrder = "TermOrder"
            case courses = "Courses"
        }

        public var schoolName: String
        public var year: String
        public var termName: String
        public var termOrder: Int
        public var courses: [CourseData]

        public var id: String {
            schoolName + year + termName
        }
    }

    public struct CourseHistoryData: Decodable, Identifiable {
        enum CodingKeys: String, CodingKey {
            case grade = "Grade"
            case gradeLevelOrder = "GradeLevelOrder"
            case terms = "Terms"
        }

        public var grade: String
        public var gradeLevelOrder: Int
        public var terms: [CourseHistoryTerm]

        public var id: String {
            grade + String(gradeLevelOrder) + String(terms.count)
        }
    }
}
