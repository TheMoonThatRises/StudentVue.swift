//
//  PXPMessages.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct MessageListing: XMLObjectDeserialization {
        var iconURL: String?
        var id: String?
        var beginDate: Date
        var type: String
        var subject: String
        var content: String?
        var read: Bool
        var deletable: Bool
        var from: String?
        var subjectNoHTML: String
        var module: String?
        var attachmentData: [String]? // TODO: Find data type/structure

        public static func deserialize(_ element: XMLIndexer) throws -> MessageListing {
            MessageListing(iconURL: element.value(ofAttribute: "IconURL"),
                           id: element.value(ofAttribute: "ID"),
                           beginDate: try element.value(ofAttribute: "BeginDate"),
                           type: try element.value(ofAttribute: "Type"),
                           subject: try element.value(ofAttribute: "Subject"),
                           content: element.value(ofAttribute: "Content"),
                           read: try element.value(ofAttribute: "Read"),
                           deletable: try element.value(ofAttribute: "Deletable"),
                           from: element.value(ofAttribute: "From"),
                           subjectNoHTML: try element.value(ofAttribute: "SubjectNoHTML"),
                           module: element.value(ofAttribute: "Module"))
        }
    }

    public struct SynergyMessageListingByStudent: XMLObjectDeserialization {
        var studentGU: String
        var messageListings: [MessageListing]

        public static func deserialize(_ element: XMLIndexer) throws -> SynergyMessageListingByStudent {
            SynergyMessageListingByStudent(studentGU: try element.value(ofAttribute: "StudentGU"),
                                           messageListings: try element["SynergyMailMessageListings"].children.map { try $0.value() })
        }
    }

    public struct PXPMessages: XMLObjectDeserialization {
        var messageListings: [MessageListing]
        var synergyMessageListingsByStudents: [SynergyMessageListingByStudent]

        public static func deserialize(_ element: XMLIndexer) throws -> PXPMessages {
            let messages = element["PXPMessagesData"]

            return PXPMessages(messageListings: try messages["MessageListings"].children.map { try $0.value() },
                               synergyMessageListingsByStudents: try messages["SynergyMailMessageListingByStudents"].children.map { try $0.value() })
        }
    }
}

extension StudentVueApi.PXPMessages {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
