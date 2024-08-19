//
//  XMLHash+parse.swift
//  
//
//  Created by TheMoonThatRises on 4/14/23.
//

import Foundation
import SWXMLHash

public extension XMLHash {
    static fileprivate let errorAttributes = ["ERROR_MESSAGE", "errorMessage"]

    /// Wrapper of XMLHash parse function
    ///
    /// - Parameter soapString: The SOAP XML to parse
    ///
    /// - Throws: `StudentVueErrors.soapError` An error was returned by the StudentVue API
    ///
    /// - Returns: An XMLIndexer with only the body of the SOAP response
    class func parse(soapString: String) throws -> XMLIndexer {
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
