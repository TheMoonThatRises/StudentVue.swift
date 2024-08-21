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

        /// The ID of the class.
        public var courseID: String

        /// The name of the class.
        public var courseTitle: String

        /// Credits attempted from the class.
        public var creditsAttempted: String

        /// Credits successfully completed from the class.
        public var creditsCompleted: String

        /// Unknown.
        public var verifiedCredit: String

        /// Grade in the gradebook.
        public var mark: String

        /// Name of the grade school. Should be either primary or secondary school.
        public var chsType: String

        /// Unique identifier for the structure.
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

        /// Name of the school.
        public var schoolName: String

        /// Year of attendance for the school.
        public var year: String

        /// Name of the term when the student took the school.
        public var termName: String

        /// Unknown.
        public var termOrder: Int

        /// List of courses taken during the term at the school.
        public var courses: [CourseData]

        /// Unique identifier for the structure.
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

        /// Most recent grade level taken by the student.
        public var grade: String

        /// Unknown.
        public var gradeLevelOrder: Int

        /// List of terms. Includes all terms from primary to secondary school.
        public var terms: [CourseHistoryTerm]

        /// Unique identifier of the structure.
        public var id: String {
            grade + String(gradeLevelOrder) + String(terms.count)
        }
    }
}
