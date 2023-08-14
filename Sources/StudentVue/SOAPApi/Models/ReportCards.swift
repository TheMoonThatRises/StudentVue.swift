//
//  ReportCards.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct RCReportingPeriod: XMLObjectDeserialization {
        public var reportingPeriodGU: String
        public var reportingPeriodName: String
        public var endDate: Date
        public var message: String
        public var documentGU: String

        public static func deserialize(_ element: XMLIndexer) throws -> RCReportingPeriod {
            RCReportingPeriod(reportingPeriodGU: try element.value(ofAttribute: "ReportingPeriodGU"),
                              reportingPeriodName: try element.value(ofAttribute: "ReportingPeriodName"),
                              endDate: try element.value(ofAttribute: "EndDate"),
                              message: try element.value(ofAttribute: "Message"),
                              documentGU: try element.value(ofAttribute: "DocumentGU"))
        }
    }

    public struct ReportCards: XMLObjectDeserialization {
        public var rcReportingPeriods: [RCReportingPeriod]

        public static func deserialize(_ element: XMLIndexer) throws -> ReportCards {
            ReportCards(rcReportingPeriods: try element["RCReportingPeriodData"]["RCReportingPeriods"]["RCReportingPeriod"].value())
        }
    }

    public struct ReportCard: XMLObjectDeserialization {
        public var documentGU: String
        public var fileName: String
        public var docFileName: String
        public var docType: String
        public var base64Code: String

        public static func deserialize(_ element: XMLIndexer) throws -> ReportCard {
            let reportCard = element["DocumentData"]

            return ReportCard(documentGU: try reportCard.value(ofAttribute: "DocumentGU"),
                              fileName: try reportCard.value(ofAttribute: "FileName"),
                              docFileName: try reportCard.value(ofAttribute: "DocFileName"),
                              docType: try reportCard.value(ofAttribute: "DocType"),
                              base64Code: try reportCard["Base64Code"].value())
        }
    }
}

extension StudentVueApi.ReportCards {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}

extension StudentVueApi.ReportCard {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
