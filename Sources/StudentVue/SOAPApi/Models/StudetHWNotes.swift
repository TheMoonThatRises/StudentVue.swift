//
//  StudentHWNotes.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/13/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    /// Undocumented API.
    public struct StudentHWNotes: XMLObjectDeserialization {
        /// GU of the student.
        public var studentGU: String

        /// Student information system number.
        public var sisNumber: String

        /// Unkown.
        public var studentSSY: String

        /// Unkown.
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
