//
//  ScraperStudentInfo.swift
//
//
//  Created by TheMoonThatRises on 3/10/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    public struct StudentInfo {
        var id: String
        var name: String
        var grade: Int
        var school: String
        var phone: String
        var photo: URL?

        public init?(html: String) throws {
            let doc = try SwiftSoup.parse(html)

            self.name = try doc.getElementsByTag("h1")
                .first(where: { $0.hasClass("hide-for-screen no-border") })?.text() ?? ""
            self.grade = Int(try doc.getElementsByTag("div")
                .first(where: { $0.hasClass("student-grade-description hide-for-screen") })?
                .text()
                .trimmingCharacters(in: .numbers) ?? "") ?? 0

            if let navigationData = try NavigationData(html: html),
               let currentStudent = navigationData.students.first(where: { $0.current }) {
                self.school = currentStudent.school
                self.id = currentStudent.sisNumber
                self.phone = currentStudent.phone
                self.photo = URL(string: "\(StudentVue.domain)/\(currentStudent.photo)")
            } else {
                self.school = try doc.getElementsByClass("school").first()?.text() ?? ""
                self.id = (try doc.getElementsByClass("student-id").first()?.text() ?? "")
                    .replacingOccurrences(of: "ID: ", with: "")
                self.phone = try doc.getElementsByClass("phone").first()?.text() ?? ""

                if let photoFile = try doc.getElementsByClass("student-photo").select("img").first()?.attr("src") {
                    self.photo = URL(string: "\(StudentVue.domain)/\(photoFile)")
                }
            }

            guard !self.name.isEmpty else {
                return nil
            }
        }
    }
}
