//
//  ErrorPage.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 3/15/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    internal struct ErrorPage {
        /// Parses scraped HTML page from StudentVue checks for errors.
        ///
        /// This method checks for elements containing the id `USER_ERROR` or
        /// `ctl00_MainContent_ERROR`, which are in the HTML when errors occur.
        ///
        /// - Parameter html: Scraped HTML page from StudentVue.
        ///
        /// - Throws: Either ``StudentVueScraper/ScraperErrors/unknown(message:)`` or
        ///           ``StudentVueScraper/ScraperErrors/invalidUsername`` depending on the error.
        public static func parse(html: String) throws {
            let doc = try SwiftSoup.parse(html)

            if let error = try doc.getElementById("USER_ERROR")?.text(), !error.isEmpty {
                throw ScraperErrors.unknown(message: error)
            } else if let error = try doc.getElementById("ctl00_MainContent_ERROR")?.text().lowercased(), !error.isEmpty {
                if error.contains("incorrect") {
                    throw ScraperErrors.incorrectPassword
                } else if error.contains("invalid") {
                    throw ScraperErrors.invalidUsername
                } else {
                    throw ScraperErrors.unknown(message: error)
                }
            }
        }
    }
}
