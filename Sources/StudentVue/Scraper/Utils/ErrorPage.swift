//
//  ErrorPage.swift
//  
//
//  Created by TheMoonThatRises on 3/15/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    public struct ErrorPage {
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
