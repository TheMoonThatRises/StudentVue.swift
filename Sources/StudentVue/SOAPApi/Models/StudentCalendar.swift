//
//  StudentCalendar.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct CalendarEventList: XMLObjectDeserialization {
        var date: Date
        var title: String
        var icon: String?
        var agu: String?
        var dayType: String
        var startTime: String
        var link: String?
        var dgu: String?
        var viewType: Int?
        var addLinkData: String?

        public static func deserialize(_ element: XMLIndexer) throws -> CalendarEventList {
            CalendarEventList(date: try element.value(ofAttribute: "Date"),
                              title: try element.value(ofAttribute: "Title"),
                              icon: element.value(ofAttribute: "Icon"),
                              agu: element.value(ofAttribute: "AGU"),
                              dayType: try element.value(ofAttribute: "DayType"),
                              startTime: try element.value(ofAttribute: "StartTime"),
                              link: element.value(ofAttribute: "Link"),
                              dgu: element.value(ofAttribute: "DGU"),
                              viewType: element.value(ofAttribute: "ViewType"),
                              addLinkData: element.value(ofAttribute: "AddLinkData"))
        }
    }

    public struct StudentCalendar: XMLObjectDeserialization {
        var schoolStartDate: Date
        var schoolEndDate: Date
        var monthStartDate: Date
        var monthEndDate: Date
        var eventLists: [CalendarEventList]

        public static func deserialize(_ element: XMLIndexer) throws -> StudentCalendar {
            let calendar = element["CalendarListing"]

            return StudentCalendar(schoolStartDate: try calendar.value(ofAttribute: "SchoolBegDate"),
                                   schoolEndDate: try calendar.value(ofAttribute: "SchoolEndDate"),
                                   monthStartDate: try calendar.value(ofAttribute: "MonthBegDate"),
                                   monthEndDate: try calendar.value(ofAttribute: "MonthEndDate"),
                                   eventLists: try calendar["EventLists"].children.map { try $0.value() })
        }
    }
}

extension StudentVueApi.StudentCalendar {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
