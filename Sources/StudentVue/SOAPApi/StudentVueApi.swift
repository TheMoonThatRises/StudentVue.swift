//
//  StudentVueApi.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/3/23.
//

import Foundation
import SWXMLHash

/// Class for interacting with StudentVue's official SOAP API.
///
/// ``StudentVueApi`` recreates API requests submitted by the official StudentVue app, using
/// a combination of community compiled requests and responses and through transparent proxies.
///
/// New API endpoints and methods can be found by using MITMProxy and the official StudentVue app
/// installed on a Mac.
///
/// A new instance can be created with ``StudentVueApi/init(domain:username:password:)``, but the
/// prefered method is by using ``StudentVue/StudentVue`` and initializing with
/// ``StudentVue/StudentVue/init(domain:username:password:)`` and accessing it through its
/// ``StudentVue/StudentVue/api``.
public class StudentVueApi {
    /// The domain of the StudentVue API.
    private var domain: String

    /// The base URL to access StudentVue's API.
    private var url: String {
        "https://\(domain)/Service/"
    }

    /// The username to log into StudentVue's API.
    private var username: String

    /// The password to log into StudentVue's API.
    private var password: String

    /// Creates a new URLSession for the API section of the library to use.
    private let session: URLSession

    /// Initializes a new ``StudentVueApi`` client with user credientials.
    ///
    /// Although this initializers may be used directly, it is best to use
    /// ``StudentVue/StudentVue/init(domain:username:password:)``.  There are several methods
    /// contained by ``StudentVueApi``  that are only accessable through ``StudentVue/StudentVue``.
    ///
    /// - Parameters:
    ///   - domain: Domain of the school that uses StudentVue.
    ///   - username: The username of the student's information to access.
    ///   - password: The password of the student's information to access.
    public init(domain: String, username: String, password: String) {
        self.domain = domain

        self.username = username
        self.password = password

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Accept": "*/*",
            "Content-Type": "text/xml; charset=utf-8",
            "SOAPAction": "http://edupoint.com/webservices/ProcessWebServiceRequestMultiWeb",
            "Connection": "close",
            "Accept-Language": "en-us",
            "Accept-Encoding": "gzip, deflate"
        ]
        sessionConfig.allowsCellularAccess = true // The API only sends text responses
        sessionConfig.httpShouldSetCookies = false
        sessionConfig.httpCookieAcceptPolicy = .never

        self.session = URLSession(configuration: sessionConfig)
    }

    /// Retrieves account details as a hash.
    ///
    /// This is an internal function that should only be used by and accessed from
    /// ``StudentVue/StudentVue/getAccountHash()``.
    ///
    /// - Returns: Hash of username, password, and domain
    internal func getAccountHash() -> String {
        return AccountHasher.hash(username: username, password: password, domain: domain)
    }

    /// Updates the credentials of the user.
    ///
    /// This is an internal function that should only be used by and accessed from
    /// ``StudentVue/StudentVue/updateCredentials(domain:username:password:)``.
    ///
    /// - Parameters:
    ///   - domain: The new domain.
    ///   - username: The new username.
    ///   - password: The new password.
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

    /// Lowest level function to access StudentVue's API.
    ///
    /// This method may be directly called for certain use cases, but most of the time, it is
    /// better to call dedicated methods created by ``StudentVueApi``. Most of the StudentVue API
    /// methods are handled with proper structures and typings. However, there are certain methods
    /// not covered, which makes this method useful. To use API methods not covered by
    /// ``StudentVueApi/Methods``, you can create an extension of the enum.
    ///
    /// ```swift
    /// extension StudentVueApi.Methods {
    ///     static let anotherMethod = StudentVueApi.Methods(rawValue: "AnotherMethod")
    /// }
    ///
    /// if let anotherMethod = StudentVueApi.Methods.anotherMethod {
    ///     let item = try await client.api.makeServiceRequest(methodName: anotherMethod)
    /// }
    /// ```
    ///
    /// Although it is optional, the `params` parameter has a specific structure that needs to be
    /// follow. It uses a nested dictionary where the outer key is the tag name. The inner
    /// dictionary are the attributes, where the key `Value` is the tag content.
    ///
    /// ```swift
    /// let params = ["ReportPeriod": ["Value": "S1"]]
    ///
    /// try await client.makeServiceRequest(methodName: .gradebook, params: params)
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to access.
    ///   - methodName: The method to use, determing what data is being requested or sent.
    ///   - serviceHandle: The service handle to use.
    ///   - params: Parameters to be sent.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession or no
    ///           response returned.
    ///
    /// - Returns: A string in the format of an XML returned from the StudentVue API.
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

    /// Higher level function to access StudentVue's API.
    ///
    /// This function is a wrapper around
    /// ``StudentVueApi/makeServiceRequest(endpoint:methodName:serviceHandle:params:)``, but
    /// simply parses the output with ``SWXMLHash/XMLHash/parse(soapString:)`` for easier output handling
    /// and contains more customized error messages that can be caught.
    ///
    /// This method may be directly called for certain use cases, but most of the time, it is
    /// better to call dedicated methods created by ``StudentVueApi``. Most of the StudentVue API
    /// methods are handled with proper structures and typings. However, there are certain methods
    /// not covered, which makes this method useful. To use API methods not covered by
    /// ``StudentVueApi/Methods``, you can create an extension of the enum.
    ///
    /// ```swift
    /// extension StudentVueApi.Methods {
    ///     static let anotherMethod = StudentVueApi.Methods(rawValue: "AnotherMethod")
    /// }
    ///
    /// if let anotherMethod = StudentVueApi.Methods.anotherMethod {
    ///     let item = try await client.api.makeServiceRequest(methodName: anotherMethod)
    /// }
    /// ```
    ///
    /// Although it is optional, the `params` parameter has a specific structure that needs to be
    /// follow. It uses a nested dictionary where the outer key is the tag name. The inner
    /// dictionary are the attributes, where the key `Value` is the tag content.
    ///
    /// ```swift
    /// let params = ["ReportPeriod": ["Value": "S1"]]
    ///
    /// try await client.makeServiceRequest(methodName: .gradebook, params: params)
    /// ```
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to access.
    ///   - methodName: The method to use, determing what data is being requested or sent.
    ///   - serviceHandle: The service handle to use.
    ///   - params: Parameters to be sent.
    ///
    /// - Throws: `Error` or `StudentVueErrors`. The most common error that will be thrown is
    ///            ``StudentVueErrors/invalidCredentials``. An error thrown by URLSession or no
    ///            response returned.
    ///
    /// - Returns: The XMLIndexer parsed from the response from the StudentVue API.
    public func xmlServiceRequest(endpoint: Endpoints = .pxpCommunication,
                                  methodName: Methods,
                                  serviceHandle: WebServices = .pxpWebServices,
                                  params: [String: [String: String]] = [:]) async throws -> XMLIndexer {
        let result = try await makeServiceRequest(endpoint: endpoint,
                                                  methodName: methodName,
                                                  serviceHandle: serviceHandle,
                                                  params: params)

        return try XMLHash.parse(soapString: result)
    }

    /// Checks validity of user credentials quickly.
    ///
    /// This is an internal function that should only be used by and accessed from
    /// ``StudentVue/StudentVue/checkCredentials()``.
    ///
    /// - Throws: `Error` some other error has occured when api request was sent.
    ///
    /// - Returns: Valid credentials or not.
    internal func checkCredentials() async throws -> Bool {
        do {
            _ = try await xmlServiceRequest(methodName: .getSoundFileData)

            return true
        } catch StudentVueErrors.invalidCredentials {
            return false
        } catch {
            throw error
        }
    }

    /// Gets districts near the given zip code
    ///
    /// This method retrieves nearby districts based on zip codes. Zip codes with no nearby
    /// districts will return ``Districts`` with an empty list. This function can be accessed
    /// without credentials or logging in.
    ///
    /// ```swift
    /// let districts = try await StudentVue.getDistricts(zip: "11001")
    /// ```
    ///
    /// - Warning: This API endpoint has a rate limit of about 50-60 requests per minute, and will
    ///            result a 1 minute timeout. This issue can be accidently caused when having the
    ///            district bound to a variable in `SwiftUI` and calling this function.
    ///
    /// - Parameter zip: The zip code to search for near-by districts that use StudentVue.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///            or no response returned.
    ///
    /// - Returns: Information about the near-by district.
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

    /// Get all messages recently sent to the student.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///            or no response returned.
    ///
    /// - Returns: All message information recently sent to the student.
    public func getMessages() async throws -> PXPMessages {
        try PXPMessages(string: await makeServiceRequest(methodName: .getPXPMessages))
    }

    /// Gets all recent calendar events such as assignment due dates and school breaks.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///            or no response returned.
    ///
    /// - Returns: All recent calendar events.
    public func getCalendar() async throws -> StudentCalendar {
        try StudentCalendar(string: await makeServiceRequest(methodName: .studentCalendar))
    }

    /// Gets every absence along with other absence information.
    ///
    /// - Important: This method does not return if the student was in the class, only if they were
    ///              abscent, tardy, or had an activity.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: Every absence by date along with tardies and activity abscenses.
    public func getAttendence() async throws -> Attendance {
        try Attendance(string: await makeServiceRequest(methodName: .attendance))
    }

    /// Get all classes and assignments in the gradebook.
    ///
    /// - Parameter reportPeriod: The grading period to get. Default is the current grading period.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: All grades and grading period dates.
    public func getGradeBook(reportPeriod: String? = nil) async throws -> GradeBook {
        var params: [String: [String: String]] = [:]

        if let reportPeriod = reportPeriod {
            params["ReportPeriod"] = ["Value": reportPeriod]
        }

        return try GradeBook(string: await makeServiceRequest(methodName: .gradebook, params: params))
    }

    /// Currently unknown what this does.
    ///
    /// - Warning: No information is returned.
    ///
    /// - Experiment: Try using ``makeServiceRequest(endpoint:methodName:serviceHandle:params:)``
    ///               if student's district uses this feature to see the response.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: Unknown, partially empty data struct.
    public func getClassNotes() async throws -> StudentHWNotes {
        try StudentHWNotes(string: await makeServiceRequest(methodName: .studentHWNotes))
    }

    /// Gets all of student's information stored.
    ///
    /// Most of the information stored is information the student's parent when signing up the
    /// student for the school year. This includes doctor and dentist information, and
    /// emergency contacts among other values.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: All student information stored in StudentVue, such as name, birthdate, and address.
    public func getStudentInfo() async throws -> StudentInfo {
        try StudentInfo(string: await makeServiceRequest(methodName: .studentInfo))
    }

    /// Gets all classes that are being taken along with current day's schedule.
    ///
    /// - Parameter termIndex: The term to get the schedule for.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: All necessary class schedule information such as start/end times,, teachers, etc.
    public func getClassSchedule(termIndex: String? = nil) async throws -> ClassSchedule {
        var params: [String: [String: String]] = [:]

        if let termIndex = termIndex {
            params["TermIndex"] = ["Value": termIndex]
        }

        return try ClassSchedule(string: await makeServiceRequest(methodName: .studentClassList, params: params))
    }

    /// Gets information about the school and the school's district.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: School and district staff and representitives with their contact
    ///            information and position.
    public func getSchoolInfo() async throws -> SchoolInfo {
        try SchoolInfo(string: await makeServiceRequest(methodName: .studentSchoolInfo))
    }

    /// Get a list of report cards.
    ///
    /// This method can be used with ``getReportCard(documentGU:)`` to retrieve a specific report
    /// card.
    ///
    /// - Note: The output of this method has not been validated, proceed with caution.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: A list of report card information and document GUs.
    public func listReportCards() async throws -> ReportCards {
        try ReportCards(string: await makeServiceRequest(methodName: .getReportCardInitialData))
    }

    /// Get a report card based on its report card GU.
    ///
    /// Report card GUs can be retrieved using ``listReportCards()``.
    ///
    /// ```swift
    /// let reportCards = try await client.api.listReportCards()
    ///
    /// let docGU = reportCards.rcReportingPeriods[0].documentGU
    ///
    /// let reportCard = try await client.api.getReportCard(documentGU: docGU)
    /// ```
    ///
    /// The results from this method can be converted into a PDF file by first converting to type
    /// `Data` and then writing to file.
    ///
    /// ```swift
    /// if let data = Data(base64Encoded: reportCard.base64Code),
    ///    let url = URL(string: reportCard.fileName) {
    ///     data.write(to: url)
    /// }
    /// ```
    ///
    /// - Note: The output of this method has not been validated, proceed with caution.
    ///
    /// - Parameter documentGU: The document GU of the report card to access.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: The report card in struct containing a Base64 string.
    public func getReportCard(documentGU: String) async throws -> ReportCard {
        try ReportCard(string: await makeServiceRequest(methodName: .getReportCardDocumentData,
                                                        params: ["DocumentGU": ["Value": documentGU]]
                                                       )
        )
    }

    /// Gets a list of documents and their metadata.
    ///
    /// This method can be used with ``getDocument(documentGU:)`` to retrieve a specific document.
    ///
    /// - Note: The output of this method has not been validated, proceed with caution.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession or no response returned
    ///
    /// - Returns: A list of document GUs and other relevant document information.
    public func listDocuments() async throws -> StudentDocuments {
        try StudentDocuments(string: await makeServiceRequest(methodName: .getStudentDocumentInitialData))
    }

    /// Gets a document based on a given document GU.
    ///
    /// Docment GUs can be retrieved using ``listDocuments()``.
    ///
    /// ```swift
    /// let documents = try await client.api.listDocuments()
    ///
    /// let docGU = documents.studentDocumentDatas[0].documentGU
    ///
    /// let document = try await client.api.getDocument(documentGU: docGU)
    /// ```
    ///
    /// The results from this method can be converted into a PDF file by first converting to type
    /// `Data` and then writing to file.
    ///
    /// ```swift
    /// if let data = Data(base64Encoded: document.base64Code),
    ///    let url = URL(string: document.fileName) {
    ///     data.write(to: url)
    /// }
    /// ```
    ///
    /// - Note: The output of this method has not been validated, proceed with caution.
    ///
    /// - Parameter documentGU: The document GU of the document to access.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: The document in Base64 and other relevent document information.
    public func getDocument(documentGU: String) async throws -> StudentAttachedDocumentData {
        try StudentAttachedDocumentData(string: await makeServiceRequest(methodName: .getContentOfAttachedDoc,
                                                                         params: ["DocumentGU": ["Value": documentGU]]
                                                                        )
        )
    }

    /// Gets a message attachment based on its GU.
    ///
    /// - Warning: This method has not been tested. Returning data may be malformed
    ///            or throw an error.
    ///
    /// - Parameter smAttachmentGU: The GU of the attachment to get.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: The document in Base64 string along with its name.
    public func getMessageAttachment(smAttachmentGU: String) async throws -> MessageAttachment {
        try MessageAttachment(string: await makeServiceRequest(methodName: .synergyMailGetAttachment,
                                                               params: ["SmAttachmentGU": ["Value": smAttachmentGU]]
                                                              )
        )
    }

    /// Updates a message's status.
    ///
    /// - Warning: This method has not been tested and may not return a desired result.
    ///
    /// - Parameters:
    ///   - messageID: The ID of the message to update.
    ///   - type: The type of message that is to be updated.
    ///   - markAsRead: To mark the message as read or not. This should be kept `true`.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: The raw response of the request in dictionary form.
    public func updateMessage(messageID: String, type: String, markAsRead: Bool = true) async throws -> XMLIndexer {
        try XMLHash.parse(soapString: await makeServiceRequest(methodName: .updatePXPMessage, params: ["MessageListing": ["ID": messageID,
                                                                                                                          "Type": type, "MarkAsRead": String(markAsRead)]
                                                                                                      ]
                                                              )
        )
    }

    /// Gets the student's health records.
    ///
    /// This method will return immunization records along with health conditions
    /// and health visitations. Specific health information can be included by enabling
    /// it through certain `Bool` parameters. By default, only `healthImmunizations` is enabled.
    ///
    /// ```swift
    /// let healthInfo = try await client.api.getHealthInfo(healthConditions: false,
    ///                                                     healthVisits: true,
    ///                                                     healthImmunizations: true)
    /// ```
    ///
    /// - Warning: The data structure of `healthConditions` and `healthVisits` are currently
    ///            unknown and accessing those methods may throw an error or provide an uknown
    ///            result.
    ///
    /// - Parameters:
    ///   - healthConditions: Whether to access the health conditions of the student or not.
    ///   - healthVisits: Whether to access the health visits of the student or not.
    ///   - healthImmunizations: Whether to access the immunization records of the student or not.
    ///
    /// - Throws: `Error` or ``StudentVueErrors/emptyResponse``. An error thrown by URLSession
    ///           or no response returned.
    ///
    /// - Returns: The health information of the student.
    public func getHealthInfo(healthConditions: Bool = false,
                              healthVisits: Bool = false,
                              healthImmunizations: Bool = true) async throws -> StudentHealthInfo {
        try StudentHealthInfo(string: await makeServiceRequest(methodName: .studentHealthInfo,
                                                               params: ["HealthConditions": ["Value": String(healthConditions)],
                                                                        "HealthVisits": ["Value": String(healthVisits)],
                                                                        "HealthImmunizations": ["Value": String(healthImmunizations)]
                                                                       ]
                                                              )
        )
    }
}
