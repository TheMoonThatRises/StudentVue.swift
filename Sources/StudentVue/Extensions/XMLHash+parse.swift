//
//  XMLHash+parse.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 4/14/23.
//

import Foundation
import SWXMLHash

public extension XMLHash {
    /// Attributes SOAP messages include when an error has occured.
    static private let errorAttributes = ["ERROR_MESSAGE", "errorMessage"]

    /// Wrapper of XMLHash parse function.
    ///
    /// This function loops through all of the first layer of children in the requests looking
    /// for an attribute that is defined in `errorAttributes`. This attribute is then read and
    /// throws an error. ``StudentVueApi/StudentVueErrors/invalidCredentials`` is the only specific
    /// error message thrown. Other messages are thrown through a generic
    /// ``StudentVueApi/StudentVueErrors/soapError(_:)`` with the error message
    /// as the string value.
    ///
    /// - Note: This function may be ineffecient as it loops through all of the first layer
    ///         of the returned XML.
    ///
    /// - Parameter soapString: The SOAP XML to parse.
    ///
    /// - Throws: ``StudentVueErrors/soapError`` when an error was returned by StudentVue's API.
    ///
    /// - Returns: An XMLIndexer with only the body of the SOAP response.
    static internal func parse(soapString: String) throws -> XMLIndexer {
        let request = parse(soapString)["soap:Envelope"]["soap:Body"]["ProcessWebServiceRequestMultiWebResponse"]["ProcessWebServiceRequestMultiWebResult"]

        do {
            for child in request.children {
                for attr in XMLHash.errorAttributes {
                    guard let attrValue = child.element?.attribute(by: attr)?.text.lowercased() else {
                        continue
                    }

                    if attrValue.contains("user id") || attrValue.contains("password") {
                        throw StudentVueApi.StudentVueErrors.invalidCredentials
                    } else {
                        throw StudentVueApi.StudentVueErrors.soapError(attrValue)
                    }
                }
            }
        } catch let error as StudentVueApi.StudentVueErrors {
            throw error
        }

        return request
    }
}
