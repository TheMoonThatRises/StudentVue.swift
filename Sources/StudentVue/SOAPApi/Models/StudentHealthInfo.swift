//
//  StudentHealthInfo.swift
//  
//
//  Created by TheMoonThatRises on 4/15/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct HealthVisitListing: XMLObjectDeserialization {
        // TODO: Find data structure

        public static func deserialize(_ element: XMLIndexer) throws -> HealthVisitListing {
            HealthVisitListing()
        }
    }

    public struct HealthConditionListing: XMLObjectDeserialization {
        // TODO: Find data structure

        public static func deserialize(_ element: XMLIndexer) throws -> HealthConditionListing {
            HealthConditionListing()
        }
    }

    public struct HealthImmunizationListing: XMLObjectDeserialization {
        var accessGU: String
        var compliant: Bool
        var compliantMessage: String
        var name: String
        var numReqDoses: Int
        var immunizationDates: [Date]

        public static func deserialize(_ element: XMLIndexer) throws -> HealthImmunizationListing {
            HealthImmunizationListing(accessGU: try element.value(ofAttribute: "AccessGU"),
                                      compliant: try element.value(ofAttribute: "Compliant"),
                                      compliantMessage: try element.value(ofAttribute: "CompliantMessage"),
                                      name: try element.value(ofAttribute: "Name"),
                                      numReqDoses: try element.value(ofAttribute: "NumReqDoses"),
                                      immunizationDates: try element["ImmunizationDatesData"].children.map { try $0.value(ofAttribute: "ImmunizationDt") })
        }
    }

    public struct StudentHealthInfo: XMLObjectDeserialization {
        var healtVisitListings: [HealthVisitListing]
        var healthConditionListings: [HealthConditionListing]
        var healthImmunizationListing: [HealthImmunizationListing]

        public static func deserialize(_ element: XMLIndexer) throws -> StudentHealthInfo {
            let healthInfo = element["StudentHealthData"]

            return StudentHealthInfo(healtVisitListings: try healthInfo["HealthVisitListings"].children.map { try $0.value() },
                                     healthConditionListings: try healthInfo["HealthConditionsListings"].children.map { try $0.value() },
                                     healthImmunizationListing: try healthInfo["HealthImmunizationListings"].children.map { try $0.value() })
        }
    }
}

extension StudentVueApi.StudentHealthInfo {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
