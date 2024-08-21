//
//  ParseDate.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 3/17/23.
//

import Foundation

extension StudentVueScraper {
    internal class ParseDate {
        /// Reformats date to `M/d/yyyy`.
        ///
        /// - Parameter date: Input date to reformat.
        ///
        /// - Returns: The reformatted date or `nil` if unsuccessful.
        static public func getDate(date: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            return dateFormatter.date(from: date)
        }
    }
}
