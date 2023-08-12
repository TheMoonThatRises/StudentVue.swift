//
//  MessageAttachment.swift
//  
//
//  Created by TheMoonThatRises on 4/14/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct MessageAttachment: XMLObjectDeserialization {
        var documentName: String
        var base64Code: String

        public static func deserialize(_ element: XMLIndexer) throws -> MessageAttachment {
            let document = element["AttachmentXML"]

            return MessageAttachment(documentName: try document.value(ofAttribute: "DocumentName"),
                                     base64Code: try document["Base64Code"].value())
        }
    }
}

extension StudentVueApi.MessageAttachment {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
