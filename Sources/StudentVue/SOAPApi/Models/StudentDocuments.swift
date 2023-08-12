//
//  StudentDocuments.swift
//  
//
//  Created by TheMoonThatRises on 4/14/23.
//

import Foundation
import SWXMLHash

extension StudentVueApi {
    public struct StudentDocumentData: XMLObjectDeserialization {
        var documentGU: String
        var documentFileName: String
        var documentDate: Date
        var documentType: String
        var studentGU: String
        var documentComment: String

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
        var studentGU: String
        var studentSSY: String
        var studentDocumentDatas: [StudentDocumentData]

        public static func deserialize(_ element: XMLIndexer) throws -> StudentDocuments {
            let documents = element["StudentDocuments"]

            return StudentDocuments(studentGU: try documents.value(ofAttribute: "StudentGU"),
                                    studentSSY: try documents.value(ofAttribute: "StudentSSY"),
                                    studentDocumentDatas: try documents["StudentDocumentDatas"].children.map { try $0.value() })
        }
    }

    public struct DocumentData: XMLObjectDeserialization {
        var documentGU: String
        var studentGU: String
        var fileName: String
        var category: String
        var notes: String
        var docType: String
        var base64Code: String

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
        var documentCategoryLookups: [String]? // TODO: Find data type/structure
        var documentDatas: [DocumentData]

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
