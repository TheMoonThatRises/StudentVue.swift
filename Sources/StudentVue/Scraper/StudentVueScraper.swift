//
//  StudentVueScrapper.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 3/8/23.
//

import Foundation

public class StudentVueScraper {
    /// The domain of the StudentVue website.
    private var domain: String

    /// The user agent to use when accessing scraping the StudentVue website.
    private static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " +
    "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15"

    /// The base URL to access StudentVue's website.
    private var base: String {
        "https://\(domain)"
    }

    /// The username to log into StudentVue's website.
    private var username: String

    /// The password to log into StudentVue's website.
    private var password: String

    public struct URLSessionResponse {
        public var data: Data?
        public var response: HTTPURLResponse?
    }

    public struct HTMLURLSessionResponse {
        public var html: String
        public var response: HTTPURLResponse
        public var urlSessionResponse: URLSessionResponse
    }

    public enum HTTPMethods: String {
        case get, post
    }

    public enum HeaderType {
        case scrape, api
    }

    /// Creates a new URLSession for the scraper section of the library to use.
    private let scraperSession: URLSession

    /// Initializes a new ``StudentVueScraper`` client with user credientials.
    ///
    /// Although this initializers may be used directly, it is best to use
    /// ``StudentVue/StudentVue/init(domain:username:password:)``.  There are several methods
    /// contained by ``StudentVueScraper``  that are only accessable through ``StudentVue/StudentVue``.
    ///
    /// - Parameters:
    ///   - domain: Domain of the school that uses StudentVue.
    ///   - username: The username of the student's information to access.
    ///   - password: The password of the student's information to access.
    public init(domain: String, username: String, password: String) {
        URLSession.shared.configuration.timeoutIntervalForRequest = 120.0

        self.domain = domain
        self.username = username
        self.password = password

        let sessionConfig = URLSessionConfiguration.default

        sessionConfig.httpAdditionalHeaders = [
            "Accept-Language": "en-US,en;q=0.9",
            "Sec-Fetch-Site": "same-origin",
            "User-Agent": StudentVueScraper.userAgent,
            "Host": domain
        ]
        sessionConfig.allowsCellularAccess = true
        sessionConfig.httpShouldSetCookies = true
        sessionConfig.httpCookieAcceptPolicy = .always

        self.scraperSession = URLSession(configuration: sessionConfig)
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

    /// Builds the header of the request with the corresponding type.
    ///
    /// Headers are different when scraping the API or the HTML content of the website.
    ///
    /// ```swift
    /// var request = URLRequest(url: query)
    ///
    /// request.httpMethod = StudentVueScraper.HTTPMethods.get.rawValue
    /// request.httpBody = data
    ///
    /// buildHeaders(request: &request, headerType: .scrape)
    /// ```
    ///
    /// - Parameters:
    ///    - request: The request to update the headers for.
    ///    - headerType: The method the request is using to specialise the header.
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

        request.setValue(dest, forHTTPHeaderField: "Sec-Fetch-Dest")
        request.setValue(mode, forHTTPHeaderField: "Sec-Fetch-Mode")

        request.setValue("\(base)\(Endpoints.login.rawValue)", forHTTPHeaderField: "Origin")
        request.setValue("\(base)\(Endpoints.login.rawValue)", forHTTPHeaderField: "Referer")
    }

    /// Lowest level scraper call.
    ///
    /// This method does not throw custom error types, and only throws URL requests errors. It is
    /// recommended to use
    /// ``StudentVueScraper/autoThrowApi(endpoint:method:headerType:data:urlParams:)``
    /// instead.
    ///
    /// - Important: It is required to first login with ``StudentVueScraper/login()`` before
    ///              accessing endpoints with ``StudentVueScraper``.
    ///
    /// - Parameters:
    ///    - endpoint: The endpoint to use.
    ///    - method: The method to use when accessing the endpoint.
    ///    - headerType: The way to access the endpoint.
    ///    - data: Data to send to the endpoint.
    ///    - urlParams: Encoded url params to pass.
    ///
    /// - Returns: Data returned by the endpoint.
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

        let response = try await scraperSession.data(for: request)

        return URLSessionResponse(data: response.0, response: response.1 as? HTTPURLResponse)
    }

    /// Scraper call with specific error messages.
    ///
    /// This is a wrapper around
    /// ``StudentVueScraper/api(endpoint:method:headerType:data:urlParams:)``
    /// with custom error messages and returns ``HTMLURLSessionResponse`` instead of
    /// ``URLSessionResponse``.
    ///
    /// - Important: It is required to first login with ``StudentVueScraper/login()`` before
    ///              accessing endpoints with ``StudentVueScraper``.
    ///
    /// - Parameters:
    ///    - endpoint: The endpoint to use.
    ///    - method: The method to use when accessing the endpoint.
    ///    - headerType: The way to access the endpoint.
    ///    - data: Data to send to the endpoint.
    ///    - urlParams: Encoded url params to pass.
    ///
    /// - Throws: ``ScraperErrors/responseNot200`` if the response code is not 200,
    ///           ``ScraperErrors/emptyData`` if the returning data is empty, or other
    ///           misc parsing errors.
    ///
    /// - Returns: Data returned by the endpoint.
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

    /// Generates a new session id to scrape the website.
    ///
    /// - Throws: ``ScraperErrors/responseNot200`` if the response code is not 200,
    ///           ``ScraperErrors/emptyData`` if the returning data is empty, or other
    ///           misc parsing errors.
    ///
    /// - Returns: The variable state of the website.
    private func generateSessionId() async throws -> VueState {
        let getVueState = try await autoThrowApi(endpoint: .login,
                                                 method: .get,
                                                 urlParams: ["regenerateSessionId": "True"])

        return try VueState(html: getVueState.html)
    }

    /// Logs into StudentVue and sets the cookies.
    ///
    /// This method will return the gradebook when the login finishes logging in.
    ///
    /// - Important: It is required to first login before accessing endpoints with
    ///              ``StudentVueScraper``.
    ///
    /// - Warning: This method will take a long time to complete (~5s); it is recommended to
    ///            put this method call into a `Task`.
    ///
    /// - Throws: ``ScraperErrors/noUsername`` if no username was provided, or
    ///           ``ScraperErrors/noPassword`` if no password was provided. This may also throw
    ///           ``ScraperErrors/responseNot200`` if the response code is not 200, or
    ///           ``ScraperErrors/emptyData`` if the returning data is empty, or other
    ///            misc parsing errors.
    ///
    /// - Returns: The gradebook HTML if successful.
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

    /// Logs out of StudentVue.
    ///
    /// - Important: Once logged out, accessing other endpoints may return an error without
    ///              logging in again with ``StudentVueScraper/login()``.
    ///
    /// - Returns: True if logout was successful.
    public func logout() async throws -> Bool {
        let response = try await api(endpoint: .login, method: .post, urlParams: ["Logout": "1"])
        return response.response?.statusCode == 200
    }

    /// Retrieves gradebook by scraping the HTML.
    ///
    /// - Important: It is required to first login with ``StudentVueScraper/login()`` before
    ///              accessing this endpoint.
    ///
    /// - Returns: A class containing an array of ``ClassData``.
    @available(swift, deprecated: 0.1.0, message: "Use StudentVueApi.GradeBook instead.")
    public func getGradeBook() async throws -> GradeBook {
        let response = try await autoThrowApi(endpoint: .gradeBook)

        return try await GradeBook(html: response.html, client: self)
    }

    /// Retrieves course history by scraping the HTML.
    ///
    /// - Important: It is required to first login with ``StudentVueScraper/login()`` before
    ///              accessing this endpoint.
    ///
    /// - Returns: A class containing an array of ``CourseData``.
    public func getCourseHistory() async throws -> CourseHistory {
        let response = try await autoThrowApi(endpoint: .courseHistory)

        return try await CourseHistory(html: response.html)
    }
}
