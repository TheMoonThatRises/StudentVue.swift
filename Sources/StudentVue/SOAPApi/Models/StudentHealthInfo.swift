//
//  StudentHealthInfo.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/15/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    /// Undocumented API.
    public struct HealthVisitListing: XMLObjectDeserialization {
        // TODO: Find data structure

        public static func deserialize(_ element: XMLIndexer) throws -> HealthVisitListing {
            HealthVisitListing()
        }
    }

    /// Undocumented API.
    public struct HealthConditionListing: XMLObjectDeserialization {
        // TODO: Find data structure

        public static func deserialize(_ element: XMLIndexer) throws -> HealthConditionListing {
            HealthConditionListing()
        }
    }

    /// Immunization records of the student submitted by their parent when registering
    /// their student through StudentVue.
    public struct HealthImmunizationListing: XMLObjectDeserialization {
        /// GU of the immunization item.
        public var accessGU: String

        /// If the student is compliant with the immunization.
        public var compliant: Bool

        /// If the student needs to take the immunization.
        public var compliantMessage: String

        /// Name of the immunization shot.
        public var name: String

        /// Number of required doses.
        public var numReqDoses: Int

        /// Dates the student was immunized.
        public var immunizationDates: [Date]

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
        /// List of student health visits.
        public var healtVisitListings: [HealthVisitListing]

        /// List of student health conditions.
        public var healthConditionListings: [HealthConditionListing]

        /// List of student immunization records.
        public var healthImmunizationListing: [HealthImmunizationListing]

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

extension StudentVueApi.HealthImmunizationListing: Identifiable, Equatable {
    public var id: String {
        accessGU
    }

    public static func == (lhs: StudentVueApi.HealthImmunizationListing, rhs: StudentVueApi.HealthImmunizationListing) -> Bool {
        lhs.id == rhs.id
    }
}
