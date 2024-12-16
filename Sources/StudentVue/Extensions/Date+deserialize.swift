//
//  Date+deserialize.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/12/23.
//

import Foundation
import SWXMLHash

extension Date: XMLValueDeserialization {
    /// Allows for deserialization of dates from an `XMLElement`.
    ///
    /// - Parameter element: `XMLElement` where the date is parsed.
    ///
    /// - Throws: `XMLDeserializationError.typeConversionFailed` when unable to convert
    ///           `XMLElement` to `Date`.
    ///
    /// - Returns: `Date` converted from `XMLElement`.
    public static func deserialize(_ element: XMLHash.XMLElement) throws -> Date {
        let date = stringToDate(element.text)

        guard let validDate = date else {
            throw XMLDeserializationError.typeConversionFailed(type: "Date", element: element)
        }

        return validDate
    }

    /// Allows for deserialization of dates from an `XMLAttribute`.
    ///
    /// - Parameter attribute: `XMLAttribute` where the date is parsed.
    ///
    /// - Throws: `XMLDeserializationError.typeConversionFailed` when unable to convert
    ///           `XMLAttribute` to `Date`.
    ///
    /// - Returns: `Date` converted from `XMLAttribute`.
    public static func deserialize(_ attribute: XMLAttribute) throws -> Date {
        let date = stringToDate(attribute.text)

        guard let validDate = date else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "Date", attribute: attribute)
        }

        return validDate
    }
}
