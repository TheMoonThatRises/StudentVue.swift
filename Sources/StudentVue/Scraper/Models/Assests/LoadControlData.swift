//
//  LoadControlData.swift
//  
//
//  Created by TheMoonThatRises on 3/19/23.
//

import Foundation

struct LoadControlParams: Decodable {
    enum CodingKeys: String, CodingKey {
        case controlName = "ControlName"
        case hideHeader = "HideHeader"
    }

    var controlName: String
    var hideHeader: Bool
}

struct LoadControlFocusArgs: Codable {
    enum CodingKeys: String, CodingKey {
        case agu = "AGU"
        case orgYearGU = "OrgYearGU"
        case viewName, studentGU, schoolID, classID, markPeriodGU, gradePeriodGU, subjectID, teacherID, assignmentID,
             standardIdentifier, gradingPeriodGroup
    }

    var viewName: String?
    var studentGU: String
    var schoolID: Int
    var classID: Int
    var markPeriodGU: String
    var gradePeriodGU: String
    var subjectID: Int
    var teacherID: Int
    var assignmentID: Int
    var standardIdentifier: String?
    var agu: String
    var orgYearGU: String
    var gradingPeriodGroup: String?
}

struct LoadControlData: Decodable {
    enum CodingKeys: String, CodingKey {
        case loadParams = "LoadParams"
        case focusArgs = "FocusArgs"
    }

    var loadParams: LoadControlParams
    var focusArgs: LoadControlFocusArgs
}

struct SendableLoadControlRequest: Encodable {
    var control: String
    var parameters: LoadControlFocusArgs
}

struct SendableLoadControlData: Encodable {
    var request: SendableLoadControlRequest
}

extension LoadControlData {
    init() {
        self.loadParams = LoadControlParams(controlName: "", hideHeader: false)
        self.focusArgs = LoadControlFocusArgs(studentGU: "Gradebook_ClassDetails",
                                              schoolID: 0,
                                              classID: 0,
                                              markPeriodGU: "",
                                              gradePeriodGU: "",
                                              subjectID: -1,
                                              teacherID: -1,
                                              assignmentID: -1,
                                              agu: "0",
                                              orgYearGU: "")
    }

    init(with jsonString: String) throws {
        self = try JSONDecoder().decode(LoadControlData.self,
                                        from: jsonString.data(using: .utf8)!)
    }

    func toRequestable() throws -> Data? {
        try JSONEncoder().encode(SendableLoadControlData(with: self))
    }
}

extension SendableLoadControlData {
    init(with loadControlData: LoadControlData) {
        self.request = SendableLoadControlRequest(control: loadControlData.loadParams.controlName,
                                                  parameters: loadControlData.focusArgs)
    }
}
