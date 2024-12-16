//
//  NavigationData.swift
//  StudentVue
//
//  Created by Peter Duanmu on 3/16/23.
//

import Foundation
import SwiftSoup

extension StudentVueScraper {
    internal struct NavigationDataItem: Decodable {
        var moduleIcon: String
        var activeClass: String
        var url: String
        var description: String
        var notificationIcon: String
        var iconExists: Bool
        var enabled: Bool
    }

    internal struct NavigationDataStudent: Decodable {
        var agu: String
        var name: String
        var sisNumber: String
        var school: String
        var phone: String
        var photo: String
        var current: Bool
    }

    internal struct NavigationData: Decodable {
        var items: [NavigationDataItem]
        var students: [NavigationDataStudent]
    }
}

extension StudentVueScraper.NavigationData {
    /// Parses scraped StudentVue website for navigation data.
    init?(html: String) throws {
        let doc = try SwiftSoup.parse(html)

        let navigationString = String(try doc.getElementsByTag("script")
            .first(where: { $0.data().contains("PXP.NavigationData") })?
            .data()
            .matches("PXP\\.NavigationData = \\{(.|\n|\r|\t)+?\\};")
            .first ?? "")

        if !navigationString.isEmpty,
           let parenIdx = navigationString.firstIndex(of: "{"),
           let navigationData = String(navigationString[parenIdx...])
            .dropLast()
            .data(using: .utf8) {
            self = try JSONDecoder().decode(StudentVueScraper.NavigationData.self, from: navigationData)
        } else {
            return nil
        }
    }
}
