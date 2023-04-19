//
//  File.swift
//  
//
//  Created by TheMoonThatRises on 4/16/23.
//

import Foundation
import SWXMLHash

extension Date {
    /// Formats of dates StudentVue returns
    private static let decodeDateFormats = ["MM/dd/yy", "MM/dd/yy HH:mm:ss", "MM/dd/yy HH:mm:ss a", "yyyy-MM-dd'T'HH:mm:ss", "HH:mm a"]

    /// Converts String to Date using a defined array of date formats
    ///
    /// - Parameter dateAsString: The date to be converted as a string
    ///
    /// - Returns: Date converted from a string
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
