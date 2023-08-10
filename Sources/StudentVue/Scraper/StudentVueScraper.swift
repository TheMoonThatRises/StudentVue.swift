//
//  StudentVueScrapper.swift
//  
//
//  Created by TheMoonThatRises on 3/8/23.
//

import Foundation

struct URLSessionResponse {
    var data: Data?
    var response: HTTPURLResponse?
}

struct HTMLURLSessionResponse {
    var html: String
    var response: HTTPURLResponse
    var urlSessionResponse: URLSessionResponse
}

class StudentVueScraper {
    public let domain: String

    public let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " +
    "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15"
    public let base: String

    public let username: String
    public let password: String

    // All of StudentVue's endpoint
    enum Endpoints: String {
        case assessment = "/PXP2_Assessment.aspx"
        case attendence = "/PXP2_Attendance.aspx"
        case calendar = "/PXP2_Calendar.aspx"
        case classSchedule = "/PXP2_ClassSchedule.aspx"
        case conference = "/PXP2_Conference.aspx"
        case courseHistory = "/PXP2_CourseHistory.aspx"
        case courseRequest = "/PXP2_CourseRequest.aspx"
        case graduationRequirements = "/PXP2_UserModule.aspx"
        case digitalLocker = "/PXP2_DigitalLocker.aspx"
        case fee = "/PXP2_Fee.aspx"
        case gradeBook = "/PXP2_Gradebook.aspx"
        case health = "/PXP2_Health.aspx"
        case login = "/PXP2_Login_Student.aspx"
        case mail = "/PXP2_Messages.aspx"
        case mtss = "/PXP2_MTSS.aspx"
        case reportCard = "/PXP2_ReportCard.aspx"
        case schoolInformation = "/PXP2_SchoolInformation.aspx"
        case studentInfo = "/PXP2_Student.aspx"

        case loadControl = "/service/PXP2Communication.asmx/LoadControl"
    }

    enum HTTPMethods: String {
        case get, post
    }

    enum HeaderType {
        case scrape, api
    }

    /// Initializes a new StudentVueScraper client with user credientials
    ///
    /// - Parameters:
    ///   - domain: Domain of the school that uses StudentVue. Should be something like `something.edupoint.com`
    ///   - username: The username of the student's information to access
    ///   - password: The password of the student's information to access
    ///
    /// - Returns: A new StudentVueScraper client
    init(domain: String, username: String, password: String) {
        URLSession.shared.configuration.timeoutIntervalForRequest = 120.0
        self.domain = domain
        self.base = "https://\(self.domain)"
        self.username = username
        self.password = password
    }

    /// Build the header of the request with the corresponding type
    ///
    /// - Parameters:
    ///    - request: The request to set headers
    ///    - headerType: The method the request is using to specialise the header
    private func buildHeaders(request: inout URLRequest, headerType: HeaderType) {
        var accept: String
        var contentType: String
        var dest: String
        var mode: String

        switch headerType {
        case .scrape:
            accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
            contentType = "application/x-www-form-urlencoded"
            dest = "document"
            mode = "navigate"
        case .api:
            accept = "application/json, text/javascript, */*; q=0.01"
            contentType = "application/json; charset=utf-8"
            dest = "empty"
            mode = "cors"
            request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        }

        request.setValue(accept, forHTTPHeaderField: "Accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("en-US,en;q=0.9", forHTTPHeaderField: "Accept-Langauge")

        request.setValue(dest, forHTTPHeaderField: "Sec-Fetch-Dest")
        request.setValue(mode, forHTTPHeaderField: "Sec-Fetch-Mode")
        request.setValue("same-origin", forHTTPHeaderField: "Sec-Fetch-Site")

        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        request.setValue(domain, forHTTPHeaderField: "Host")
        request.setValue("\(base)\(Endpoints.login.rawValue)", forHTTPHeaderField: "Origin")
        request.setValue("\(base)\(Endpoints.login.rawValue)", forHTTPHeaderField: "Referer")
    }

    /// Lowest level scraper call without throwing types
    ///
    /// - Parameters:
    ///    - endpoint: The endpoint to use
    ///    - method: The method to use when accessing the endpoint
    ///    - headerType: The way to access the endpoint
    ///    - data: Data to send to the endpoint
    ///    - urlParams: Encoded url params to pass
    ///
    /// - Returns: Data returned by the endpoint
    public func api(endpoint: Endpoints,
                    method: HTTPMethods = .get,
                    headerType: HeaderType = .scrape,
                    data: Data? = nil,
                    urlParams: [AnyHashable: Any]? = nil) async throws -> URLSessionResponse {
        let url = base + endpoint.rawValue

        var queryUrl = URLComponents(string: url)

        if let urlParams = urlParams {
            queryUrl?.queryItems = urlParams.map { URLQueryItem(name: "\($0)", value: "\($1)") }
        }

        guard let query = queryUrl?.url else {
            return URLSessionResponse(data: nil, response: nil)
        }

        var request = URLRequest(url: query)

        request.httpMethod = method.rawValue
        request.httpBody = data

        buildHeaders(request: &request, headerType: headerType)

        let response = try await URLSession.shared.data(for: request)

        return URLSessionResponse(data: response.0, response: response.1 as? HTTPURLResponse)
    }


    /// Scraper call with specific error messages
    ///
    /// - Parameters:
    ///    - endpoint: The endpoint to use
    ///    - method: The method to use when accessing the endpoint
    ///    - headerType: The way to access the endpoint
    ///    - data: Data to send to the endpoint
    ///    - urlParams: Encoded url params to pass
    ///
    /// - Returns: Data returned by the endpoint
    public func autoThrowApi(endpoint: Endpoints,
                             method: HTTPMethods = .get,
                             headerType: HeaderType = .scrape,
                             data: Data? = nil,
                             urlParams: [AnyHashable: Any]? = nil) async throws -> HTMLURLSessionResponse {
        let response = try await api(endpoint: endpoint,
                                     method: method,
                                     headerType: headerType,
                                     data: data,
                                     urlParams: urlParams)

        guard let httpResponse = response.response, httpResponse.statusCode == 200 else {
            throw ScraperErrors.responseNot200
        }

        guard let data = response.data, let html = String(data: data, encoding: .utf8) else {
            throw ScraperErrors.emptyData
        }

        try ErrorPage.parse(html: html)

        return HTMLURLSessionResponse(html: html, response: httpResponse, urlSessionResponse: response)
    }

    /// Generates a new session id to scrape the website
    ///
    /// - Returns: The variable state of the website
    private func generateSessionId() async throws -> VueState {
        let getVueState = try await autoThrowApi(endpoint: .login,
                                                               method: .get,
                                                               urlParams: ["regenerateSessionId": "True"])

        return try VueState(html: getVueState.html)
    }

    /// Logs into StudentVue and sets the cookies
    ///
    /// - Returns: The gradebook HTML if successful
    public func login() async throws -> HTMLURLSessionResponse {
        guard !username.isEmpty else {
            throw ScraperErrors.noUsername
        }

        guard !password.isEmpty else {
            throw ScraperErrors.noPassword
        }

        let vueState = try await generateSessionId()
        let loginData = LoginData(vueState: vueState, username: username, password: password)

        return try await autoThrowApi(endpoint: .login, method: .post, data: loginData.data)
    }

    /// Log out of StudentVue
    ///
    /// - Returns: True if logout was successful
    public func logout() async throws -> Bool {
        let response = try await api(endpoint: .login, method: .post, urlParams: ["Logout": "1"])
        return response.response?.statusCode == 200
    }
}
