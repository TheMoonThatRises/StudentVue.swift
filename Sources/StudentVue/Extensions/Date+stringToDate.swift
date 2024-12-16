//
//  Date+stringToDate.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/16/23.
//

import Foundation
import SWXMLHash

extension Date {
    /// Formats of dates StudentVue returns.
    private static let decodeDateFormats = [
        "MM/dd/yy",
        "MM/dd/yy HH:mm:ss",
        "MM/dd/yy HH:mm:ss a",
        "yyyy-MM-dd'T'HH:mm:ss",
        "HH:mm a"
    ]

    /// Converts `String` to `Date` using a defined array of date formats.
    ///
    /// - Parameter dateAsString: The date to be converted as a string.
    ///
    /// - Returns: `Date` converted from a s`String` or `nil` if the input is
    ///            not an accepted formatted.
    public static func stringToDate(_ dateAsString: String) -> Date? {
        let dateFormatter = DateFormatter()

        for format in decodeDateFormats {
            dateFormatter.dateFormat = format

            if let formatted = dateFormatter.date(from: dateAsString) {
                return formatted
            }
        }

        return nil
    }
}
