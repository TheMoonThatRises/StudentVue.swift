//
//  StudentHWNotes.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct StudentHWNotes: XMLObjectDeserialization {
        public var studentGU: String
        public var sisNumber: String
        public var studentSSY: String
        public var gBHomeWorkNotesRecords: [String]? // TODO: Find data type/structure

        public static func deserialize(_ element: XMLIndexer) throws -> StudentHWNotes {
            let notes = element["GBHWNotesDatas"]

            return StudentHWNotes(studentGU: try notes.value(ofAttribute: "StudentGU"),
                                  sisNumber: try notes.value(ofAttribute: "sisNumber"),
                                  studentSSY: try notes.value(ofAttribute: "StudentSSY"))
        }
    }
}

extension StudentVueApi.StudentHWNotes {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
