//
//  XMLHash+parse.swift
//  
//
//  Created by TheMoonThatRises on 4/14/23.
//

import Foundation
import SWXMLHash

public extension XMLHash {
    /// Wrapper of XMLHash parse function
    ///
    /// - Parameter soapString: The SOAP XML to parse
    ///
    /// - Throws: `StudentVueErrors.soapError` An error was returned by the StudentVue API
    ///
    /// - Returns: An XMLIndexer with only the body of the SOAP response
    class func parse(soapString: String) throws -> XMLIndexer {
        let request = parse(soapString)["soap:Envelope"]["soap:Body"]["ProcessWebServiceRequestResponse"]["ProcessWebServiceRequestResult"]

        do {
            throw StudentVueErrors.soapError(try request["RT_ERROR"].value(ofAttribute: "ERROR_MESSAGE"))
        } catch let error as StudentVueErrors {
            throw error
        } catch {
            return request
        }
    }
}
