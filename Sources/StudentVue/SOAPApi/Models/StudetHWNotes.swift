//
//  StudentHWNotes.swift
//  
//
//  Created by TheMoonThatRises on 4/13/23.
//

import Foundation
import SWXMLHash

struct StudentHWNotes: XMLObjectDeserialization {
    var studentGU: String
    var sisNumber: String
    var studentSSY: String
    var gBHomeWorkNotesRecords: [String]? // TODO: Find data type/structure

    static func deserialize(_ element: XMLIndexer) throws -> StudentHWNotes {
        let notes = element["GBHWNotesDatas"]

        return StudentHWNotes(studentGU: try notes.value(ofAttribute: "StudentGU"),
                              sisNumber: try notes.value(ofAttribute: "sisNumber"),
                              studentSSY: try notes.value(ofAttribute: "StudentSSY"))
    }
}

extension StudentHWNotes {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}
