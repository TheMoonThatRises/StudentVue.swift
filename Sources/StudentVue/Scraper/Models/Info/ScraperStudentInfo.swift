//
//  ScraperStudentInfo.swift
//  StudentVue
//
//  Created by Peter Duanmu on 3/10/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    @available(swift, deprecated: 0.1.0, message: "Use StudentVueApi.StudentInfo instead.")
    public struct StudentInfo {
        public var studentInfo: StudentInfoData

        public init?(html: String) throws {
            let doc = try SwiftSoup.parse(html)

            self.studentInfo = StudentInfoData(id: "", name: "", grade: 0, school: "", phone: "")

            self.studentInfo.name = try doc.getElementsByTag("h1")
                .first(where: { $0.hasClass("hide-for-screen no-border") })?.text() ?? ""
            self.studentInfo.grade = Int(try doc.getElementsByTag("div")
                .first(where: { $0.hasClass("student-grade-description hide-for-screen") })?
                .text()
                .trimmingCharacters(in: .numbers) ?? "") ?? 0

            if let navigationData = try NavigationData(html: html),
               let currentStudent = navigationData.students.first(where: { $0.current }) {
                self.studentInfo.school = currentStudent.school
                self.studentInfo.id = currentStudent.sisNumber
                self.studentInfo.phone = currentStudent.phone
                self.studentInfo.photo = URL(string: "\(StudentVue.domain)/\(currentStudent.photo)")
            } else {
                self.studentInfo.school = try doc.getElementsByClass("school").first()?.text() ?? ""
                self.studentInfo.id = (try doc.getElementsByClass("student-id").first()?.text() ?? "")
                    .replacingOccurrences(of: "ID: ", with: "")
                self.studentInfo.phone = try doc.getElementsByClass("phone").first()?.text() ?? ""

                if let photoFile = try doc.getElementsByClass("student-photo").select("img").first()?.attr("src") {
                    self.studentInfo.photo = URL(string: "\(StudentVue.domain)/\(photoFile)")
                }
            }

            guard !self.studentInfo.name.isEmpty else {
                return nil
            }
        }
    }
}
