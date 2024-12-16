//
//  StudentCalendar.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    /// Calendar event.
    public struct CalendarEventList: XMLObjectDeserialization {
        /// Calendar event date.
        public var date: Date

        /// Name of the event.
        public var title: String

        /// Unkown.
        public var icon: String?

        /// Unkown.
        public var agu: String?

        /// Type of event.
        public var dayType: String

        /// Event start time.
        public var startTime: String

        /// Unkown.
        public var link: String?

        /// Unkown.
        public var dgu: String?

        /// Unkown.
        public var viewType: Int?

        /// Unkown.
        public var addLinkData: String?

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

    /// School calendar which contains assignment due dates, holidays, and school breaks.
    public struct StudentCalendar: XMLObjectDeserialization {
        /// Start date of the school.
        public var schoolStartDate: Date

        /// End date of the school.
        public var schoolEndDate: Date

        /// Starting month of the school.
        public var monthStartDate: Date

        /// Ending month of the school.
        public var monthEndDate: Date

        /// List of events.
        public var eventLists: [CalendarEventList]

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

extension StudentVueApi.CalendarEventList: Identifiable, Equatable {
    public var id: String {
        date.description + title
    }

    public static func == (lhs: StudentVueApi.CalendarEventList, rhs: StudentVueApi.CalendarEventList) -> Bool {
        lhs.id == rhs.id
    }
}
