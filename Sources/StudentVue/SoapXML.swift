//
//  SoapXML.swift
//  
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation

struct SoapXML {
    var userID: String
    var password: String
    var skipLoginLog: Bool
    var parent: Bool
    var webServiceHandleName: StudentVue.WebServices
    var methodName: StudentVue.Methods
    var paramStr: [String: [String: String]]

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

    var formatted: String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <soap:Body>
                <ProcessWebServiceRequest xmlns="http://edupoint.com/webservices/">
                     <userID>\(userID)</userID>
                     <password>\(password)</password>
                     <skipLoginLog>\(skipLoginLog ? 1 : 0)</skipLoginLog>
                     <parent>\(parent ? 1 : 0)</parent>
                     <webServiceHandleName>\(webServiceHandleName.rawValue)</webServiceHandleName>
                     <methodName>\(methodName.rawValue)</methodName>
                     <paramStr>\(formattedParamStr)</paramStr>
                </ProcessWebServiceRequest>
            </soap:Body>
        </soap:Envelope>
        """
    }

    var dataFormatted: Data {
        formatted.data(using: .utf8)!
    }
}
