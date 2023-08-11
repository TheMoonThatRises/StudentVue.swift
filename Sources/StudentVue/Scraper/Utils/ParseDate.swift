//
//  ParseDate.swift
//  
//
//  Created by TheMoonThatRises on 3/17/23.
//

import Foundation

class ParseDate {
    static public func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
}
