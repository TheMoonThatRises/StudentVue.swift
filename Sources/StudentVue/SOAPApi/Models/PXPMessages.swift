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
        public var iconURL: String?
        public var id: String?
        public var beginDate: Date
        public var type: String
        public var subject: String
        public var content: String?
        public var read: Bool
        public var deletable: Bool
        public var from: String?
        public var subjectNoHTML: String
        public var module: String?
        public var attachmentData: [String]? // TODO: Find data type/structure

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
        public var studentGU: String
        public var messageListings: [MessageListing]

        public static func deserialize(_ element: XMLIndexer) throws -> SynergyMessageListingByStudent {
            SynergyMessageListingByStudent(studentGU: try element.value(ofAttribute: "StudentGU"),
                                           messageListings: try element["SynergyMailMessageListings"].children.map { try $0.value() })
        }
    }

    public struct PXPMessages: XMLObjectDeserialization {
        public var messageListings: [MessageListing]
        public var synergyMessageListingsByStudents: [SynergyMessageListingByStudent]

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
