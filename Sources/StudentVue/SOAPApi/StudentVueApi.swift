//
//  StudentVueApi.swift
//  
//
//  Created by TheMoonThatRises on 4/3/23.
//

import Foundation
import SWXMLHash

public class StudentVueApi {
    /// Endpoints that StudentVue uses for it's API. `HDInfoCommunication` is only used within `support.edupoint.com`
    public enum Endpoints: String, Equatable {
        case pxpCommunication = "PXPCommunication"
        case hdInfoCommunication = "HDInfoCommunication"
    }

    /// SOAP methods that StudentVue uses
    public enum Methods: String {
        case getMatchingDistrictList = "GetMatchingDistrictList"
        case getPXPMessages = "GetPXPMessages"
        case studentCalendar = "StudentCalendar"
        case attendance = "Attendance"
        case gradebook = "Gradebook"
        case studentHWNotes = "StudentHWNotes"
        case studentInfo = "StudentInfo"
        case studentClassList = "StudentClassList"
        case studentSchoolInfo = "StudentSchoolInfo"
        case getReportCardInitialData = "GetReportCardInitialData"
        case getReportCardDocumentData = "GetReportCardDocumentData"
        case getStudentDocumentInitialData = "GetStudentDocumentInitialData"
        case getContentOfAttachedDoc = "GetContentOfAttachedDoc"
        case synergyMailGetAttachment = "SynergyMailGetAttachment"
        case updatePXPMessage = "UpdatePXPMessage"
        case studentHealthInfo = "StudentHealthInfo"
    }

    /// Web services that StudentVue uses. `HDInfoServices` is only used to access the`HDInfoCommunication` endpoint
    public enum WebServices: String {
        case pxpWebServices = "PXPWebServices"
        case hdInfoServices = "HDInfoServices"
    }

    private var domain: String
    /// The base URL to access StudentVue's APIs
    private var url: String {
        "https://\(domain)/Service/"
    }

    /// The username to log into StudentVue's API
    private var username: String
    /// The password to log into StudentVue's API/
    private var password: String

    /// Creates a new URLSession for the library to use
    private let session: URLSession

    /// Initializes a new StudentVueApi client with user credientials
    ///
    /// - Parameters:
    ///   - domain: Domain of the school that uses StudentVue. Should be something like `something.edupoint.com`
    ///   - username: The username of the student's information to access
    ///   - password: The password of the student's information to access
    ///
    /// - Returns: A new StudentVueApi client
    public init(domain: String, username: String, password: String) {
        self.domain = domain

        self.username = username
        self.password = password

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Accept": "*/*",
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "http://edupoint.com/webservices/ProcessWebServiceRequest",
            "Connection": "close",
            "Accept-Language": "en-us",
            "Accept-Encoding": "gzip, deflate"
        ]
        sessionConfig.allowsCellularAccess = true // The API only sends text responses
        sessionConfig.httpShouldSetCookies = false
        sessionConfig.httpCookieAcceptPolicy = .never

        self.session = URLSession(configuration: sessionConfig)
    }

    /// Updates the credentials of the user
    ///
    /// - Parameters:
    ///   - domain: The new domain
    ///   - username: The new username
    ///   - password: The new password
    internal func updateCredentials(domain: String? = nil, username: String? = nil, password: String? = nil) {
        if let domain = domain {
            self.domain = domain
        }

        if let username = username {
            self.username = username
        }

        if let password = password {
            self.password = password
        }
    }

    /// Lowest level function to access StudentVue's API
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to access
    ///   - methodName: The method to use, determing what data is being requested or sent
    ///   - serviceHandle: The service handle to use
    ///   - params: Parameters to be sent. Uses a nested dictionary where the outer key is the tag name. The inner dictionary are the attributes, where the key "Value" is the tag content
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: The string format of the XML returned from the StudentVue API
    public func makeServiceRequest(endpoint: Endpoints = .pxpCommunication,
                                   methodName: Methods,
                                   serviceHandle: WebServices = .pxpWebServices,
                                   params: [String: [String: String]] = [:]) async throws -> String {
        guard !username.isEmpty else {
            throw StudentVueErrors.noUsername
        }

        guard !password.isEmpty else {
            throw StudentVueErrors.noPassword
        }

        var request = URLRequest(url: URL(string: url + "\(endpoint.rawValue).asmx")!)
        request.httpMethod = "POST"
        request.httpBody = SoapXML(userID: username,
                                   password: password,
                                   skipLoginLog: true,
                                   parent: false,
                                   webServiceHandleName: serviceHandle,
                                   methodName: methodName,
                                   paramStr: params).dataFormatted

        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: request) { data, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let toString = String(data: data, encoding: .utf8) {
                    continuation.resume(returning: toString.unescape)
                } else {
                    continuation.resume(throwing: StudentVueErrors.emptyResponse)
                }
            }.resume()
        }
    }

    /// Gets districts near the given zip code
    ///
    /// - Parameter zip: The zip code to search for near-by districts that use StudentVue
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: Information about the near-by district
    static public func getDistricts(zip: String) async throws -> Districts {
        let studentVueClient = StudentVueApi(domain: "support.edupoint.com", username: "EdupointDistrictInfo", password: "Edup01nt")
        let districts = try await studentVueClient.makeServiceRequest(endpoint: .hdInfoCommunication,
                                                                      methodName: .getMatchingDistrictList,
                                                                      serviceHandle: .hdInfoServices,
                                                                      params: [
                                                                        "Key": ["Value": "5E4B7859-B805-474B-A833-FDB15D205D40"],
                                                                        "MatchToDistrictZipCode": ["Value": zip]
                                                                      ]
        )

        return try Districts(string: districts)
    }

    /// Get all messages recently sent to the student
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: All message information recently sent to the student
    public func getMessages() async throws -> PXPMessages {
        try PXPMessages(string: await makeServiceRequest(methodName: .getPXPMessages))
    }

    /// Gets all recent calendar events such as assignments and breaks
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: All recent calendar events
    public func getCalendar() async throws -> StudentCalendar {
        try StudentCalendar(string: await makeServiceRequest(methodName: .studentCalendar))
    }

    /// Gets every absence along with other absence information
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: Every absence by date along with tardies
    public func getAttendence() async throws -> Attendance {
        try Attendance(string: await makeServiceRequest(methodName: .attendance))
    }

    /// Get all items in the gradebook
    ///
    /// - Parameter reportPeriod: The grading period to get. Default is the current grading period
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: All grades and grading period dates
    public func getGradeBook(reportPeriod: String? = nil) async throws -> GradeBook {
        var params: [String: [String: String]] = [:]

        if let reportPeriod = reportPeriod {
            params["ReportPeriod"] = ["Value": reportPeriod]
        }

        return try GradeBook(string: await makeServiceRequest(methodName: .gradebook, params: params))
    }

    /// Currently unknown what this does
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: Unknown, partially empty data struct
    public func getClassNotes() async throws -> StudentHWNotes {
        try StudentHWNotes(string: await makeServiceRequest(methodName: .studentHWNotes))
    }

    /// Gets all of student's information stored
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: All student information stored in StudentVue, such as name, birthdate, and address
    public func getStudentInfo() async throws -> StudentInfo {
        try StudentInfo(string: await makeServiceRequest(methodName: .studentInfo))
    }

    /// Gets all classes that are being taken along with current day's schedule
    ///
    /// - Parameter termIndex: The term to get the schedule for
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: All necessary class schedule information such as start/end times, room numbers, teachers, etc
    public func getClassSchedule(termIndex: String? = nil) async throws -> ClassSchedule {
        var params: [String: [String: String]] = [:]

        if let termIndex = termIndex {
            params["TermIndex"] = ["Value": termIndex]
        }

        return try ClassSchedule(string: await makeServiceRequest(methodName: .studentClassList, params: params))
    }

    /// Gets information about the school and district
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: School and district representitives with their contact information
    public func getSchoolInfo() async throws -> SchoolInfo {
        try SchoolInfo(string: await makeServiceRequest(methodName: .studentSchoolInfo))
    }

    /// Get a list of report cards. Can be used to get a report card using `getReportCard`
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: A list of report card information and document GUs
    public func listReportCards() async throws -> ReportCards {
        try ReportCards(string: await makeServiceRequest(methodName: .getReportCardInitialData))
    }

    /// Get a report card based on its document GU
    ///
    /// - Parameter documentGU: The document GU of the report card to access. Can be retrieved with `listReportCards`
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: The report card in base64code
    public func getReportCard(documentGU: String) async throws -> ReportCard {
        try ReportCard(string: await makeServiceRequest(methodName: .getReportCardDocumentData,
                                                        params: ["DocumentGU": ["Value": documentGU]]
                                                       )
        )
    }

    /// Gets a list of document information. Can be used to get a document with `getDocument`
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: A list of document GUs and other relevant document information
    public func listDocuments() async throws -> StudentDocuments {
        try StudentDocuments(string: await makeServiceRequest(methodName: .getStudentDocumentInitialData))
    }

    /// Gets a document based on the given GU
    ///
    /// - Parameter documentGU: The document GU of the document to access. Can be retrieved with `listDocuments`
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: The document in base64code and other relevent document information
    public func getDocument(documentGU: String) async throws -> StudentAttachedDocumentData {
        try StudentAttachedDocumentData(string: await makeServiceRequest(methodName: .getContentOfAttachedDoc,
                                                                         params: ["DocumentGU": ["Value": documentGU]]
                                                                        )
        )
    }

    /// Gets a message attachment based on its GU
    ///
    /// - Parameter smAttachmentGU: The GU of the attachment to get
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: The document in base64code along with its name
    public func getMessageAttachment(smAttachmentGU: String) async throws -> MessageAttachment {
        try MessageAttachment(string: await makeServiceRequest(methodName: .synergyMailGetAttachment,
                                                               params: ["SmAttachmentGU": ["Value": smAttachmentGU]]
                                                              )
        )
    }

    /// Updates a message's status
    ///
    /// - Parameters:
    ///   - messageID: The ID of the message to update
    ///   - type: The type of message that is to be updated
    ///   - markAsRead: To mark the message as read or not. This should be kept `true`
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: The raw response of the request in dictionary form
    public func updateMessage(messageID: String, type: String, markAsRead: Bool = true) async throws -> XMLIndexer {
        try XMLHash.parse(soapString: await makeServiceRequest(methodName: .updatePXPMessage, params: ["MessageListing": ["ID": messageID,
                                                                                                                          "Type": type, "MarkAsRead": String(markAsRead)]
                                                                                                      ]
                                                              )
        )
    }

    /// Gets the student's health records
    ///
    /// - Parameters:
    ///   - healthConditions: Whether to access the health conditions of the student or not. Current data structure unknown
    ///   - healthVisits: Whether to access the health visits of the student or not. Current data struct unknown
    ///   - healthImmunizations: Whether to access the immunization records of the student or not
    ///
    /// - Throws: `Error` or `StudentVueErrors.emptyResponse`. An error thrown by URLSession or no response returned
    ///
    /// - Returns: The health information of the student
    public func getHealthInfo(healthConditions: Bool = false, healthVisits: Bool = false, healthImmunizations: Bool = true) async throws -> StudentHealthInfo {
        try StudentHealthInfo(string: await makeServiceRequest(methodName: .studentHealthInfo,
                                                               params: ["HealthConditions": ["Value": String(healthConditions)],
                                                                        "HealthVisits": ["Value": String(healthVisits)],
                                                                        "HealthImmunizations": ["Value": String(healthImmunizations)]
                                                                       ]
                                                              )
        )
    }
}
