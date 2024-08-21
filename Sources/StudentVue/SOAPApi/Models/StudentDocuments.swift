//
//  StudentDocuments.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 4/14/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    /// Student document metadata.
    public struct StudentDocumentData: XMLObjectDeserialization {
        /// GU of the document.
        public var documentGU: String

        /// File name of the document.
        public var documentFileName: String

        /// Date the document was uploaded.
        public var documentDate: Date

        /// Type of document.
        public var documentType: String

        /// GU of the student.
        public var studentGU: String

        /// Comment with the document.
        public var documentComment: String

        public static func deserialize(_ element: XMLIndexer) throws -> StudentDocumentData {
            StudentDocumentData(documentGU: try element.value(ofAttribute: "DocumentGU"),
                                documentFileName: try element.value(ofAttribute: "DocumentFileName"),
                                documentDate: try element.value(ofAttribute: "DocumentDate"),
                                documentType: try element.value(ofAttribute: "DocumentType"),
                                studentGU: try element.value(ofAttribute: "StudentGU"),
                                documentComment: try element.value(ofAttribute: "DocumentComment"))
        }
    }

    public struct StudentDocuments: XMLObjectDeserialization {
        /// GU of the student.
        public var studentGU: String

        /// Unkown.
        public var studentSSY: String

        /// List of documents the student has. Does not contain the actual document
        public var studentDocumentDatas: [StudentDocumentData]

        public static func deserialize(_ element: XMLIndexer) throws -> StudentDocuments {
            let documents = element["StudentDocuments"]

            return StudentDocuments(studentGU: try documents.value(ofAttribute: "StudentGU"),
                                    studentSSY: try documents.value(ofAttribute: "StudentSSY"),
                                    studentDocumentDatas: try documents["StudentDocumentDatas"].children.map { try $0.value() })
        }
    }

    /// Document information.
    public struct DocumentData: XMLObjectDeserialization {
        /// GU of the document.
        public var documentGU: String

        /// GU of the student.
        public var studentGU: String

        /// File name of the document.
        public var fileName: String

        /// Category of the document.
        public var category: String

        /// Notes about the document.
        public var notes: String

        /// Type of the document.
        public var docType: String

        /// The document as a Base64 string.
        public var base64Code: String

        public static func deserialize(_ element: XMLIndexer) throws -> DocumentData {
            DocumentData(documentGU: try element.value(ofAttribute: "DocumentGU"),
                         studentGU: try element.value(ofAttribute: "StudentGU"),
                         fileName: try element.value(ofAttribute: "FileName"),
                         category: try element.value(ofAttribute: "Category"),
                         notes: try element.value(ofAttribute: "Notes"),
                         docType: try element.value(ofAttribute: "DocType"),
                         base64Code: try element["Base64Code"].value())
        }
    }

    public struct StudentAttachedDocumentData: XMLObjectDeserialization {
        /// Unkown.
        public var documentCategoryLookups: [String]? // TODO: Find data type/structure

        /// List of documents.
        public var documentDatas: [DocumentData]

        public static func deserialize(_ element: XMLIndexer) throws -> StudentAttachedDocumentData {
            return StudentAttachedDocumentData(documentDatas: try element["StudentAttachedDocumentData"]["DocumentDatas"]["DocumentData"].value())
        }
    }
}

extension StudentVueApi.StudentDocuments {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}

extension StudentVueApi.StudentAttachedDocumentData {
    init(string: String) throws {
        self = try XMLHash.parse(soapString: string).value()
    }
}

extension StudentVueApi.StudentDocumentData: Identifiable, Equatable {
    public var id: String {
        documentGU
    }

    public static func == (lhs: StudentVueApi.StudentDocumentData, rhs: StudentVueApi.StudentDocumentData) -> Bool {
        lhs.id == rhs.id
    }
}
