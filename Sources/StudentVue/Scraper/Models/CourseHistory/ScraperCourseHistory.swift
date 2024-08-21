//
//  ScraperCourseHistory.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/17/24.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    public struct CourseHistory {
        /// List of courses completed by the student.
        public var courseHistory: [CourseHistoryData]

        /// Parses scraped HTML from the StudentVue website.
        ///
        /// - Parameter html: Scraped HTML StudentVue website.
        public init(html: String) async throws {
            let doc = try SwiftSoup.parse(html)

            let data = try doc.select("script")[0]
                .html()
                .matches("PXP\\.CourseHistory = \\[(.|\n|\r|\t)+?\\];")
                .first

            if let data = data,
               let idx = data.firstIndex(of: "["),
               let jsonData = String(data[idx...]).dropLast().data(using: .utf8) {
                let json = try JSONDecoder().decode([CourseHistoryData].self,
                                                    from: jsonData)

                self.courseHistory = json
            } else {
                throw ScraperErrors.invalidWebsiteHTML
            }
        }
    }
}
