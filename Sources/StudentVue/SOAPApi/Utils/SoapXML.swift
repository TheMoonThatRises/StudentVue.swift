//
//  SoapXML.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/11/23.
//

import Foundation

/// Custom SOAP XML request creator.
///
/// This constructs the data that is sent to StudentVue's SOAP API. Everything but `paramStr`
/// is required to have a value.
///
/// ``StudentVueApi/makeServiceRequest(endpoint:methodName:serviceHandle:params:)`` automatically
/// generates and sends this data package.
///
/// ```swift
/// let requestData = SoapXML(userID: "970011111",
///                           password: "password",
///                           skipLoginLog: true,
///                           parent: false,
///                           webServiceHandleName: .pxpWebServices,
///                           methodName: .gradebook,
///                           paramStr: [:])
///
/// requestData.formattedData
/// ```
struct SoapXML {
    /// Username to authenticate with.
    var userID: String

    /// Password to authenticate with.
    var password: String

    /// To skip login log or not.
    var skipLoginLog: Bool

    /// Is the authenticating account a parent.
    var parent: Bool

    /// Web service to access.
    var webServiceHandleName: StudentVueApi.WebServices

    /// Data method to access.
    var methodName: StudentVueApi.Methods

    /// Parameters to send with the request.
    var paramStr: [String: [String: String]]

    /// Formats the parameter into a HTML escaped string that is required by the SOAP API.
    private var formattedParamStr: String {
        var formattedStr = "&lt;Parms&gt;"

        for (key, attr) in paramStr {
            formattedStr += "&lt;\(key)"

            let attrs = attr.filter { $0.key.lowercased() != "value" }.map { "\($0.key)=\"\($0.value)\"" }
            formattedStr += " \(attrs.joined(separator: " "))"

            if let value = attr.first(where: { $0.key.lowercased() == "value" })?.value {
                formattedStr += "&gt;\(value)&lt;/\(key)&gt;"
            } else {
                formattedStr += " /&gt;"
            }
        }

        return formattedStr + "&lt;/Parms&gt;"
    }

    /// The data formatted as an XML.
    var formatted: String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <soap:Body>
                <ProcessWebServiceRequestMultiWeb xmlns="http://edupoint.com/webservices/">
                     <userID>\(userID)</userID>
                     <password>\(password)</password>
                     <skipLoginLog>\(skipLoginLog ? 1 : 0)</skipLoginLog>
                     <parent>\(parent ? 1 : 0)</parent>
                     <webServiceHandleName>\(webServiceHandleName.rawValue)</webServiceHandleName>
                     <methodName>\(methodName.rawValue)</methodName>
                     <paramStr>\(formattedParamStr)</paramStr>
                </ProcessWebServiceRequestMultiWeb>
            </soap:Body>
        </soap:Envelope>
        """
    }

    /// The XML as a `Data` type to be able to send through network requests.
    var dataFormatted: Data {
        formatted.data(using: .utf8)!
    }
}
