//
//  StudentVue.swift
//  
//
//  Created by TheMoonThatRises on 8/9/23.
//

import Foundation

public class StudentVue {
    // Uses the official StudentVue api endpoint
    public private(set) var api: StudentVueApi
    // Scrapes the StudentVue website
    public private(set) var scraper: StudentVueScraper
    // Client domain for other files to use
    public private(set) static var domain = ""

    /// Initializes a new StudentVue client with user credientials
    ///
    /// - Parameters:
    ///   - domain: Domain of the school that uses StudentVue. Should be something like `something.edupoint.com`
    ///   - username: The username of the student's information to access
    ///   - password: The password of the student's information to access
    ///
    /// - Returns: A new StudentVue client with api and scraper
    public init(domain: String, username: String, password: String) {
        StudentVue.domain = domain
        self.api = StudentVueApi(domain: domain, username: username, password: password)
        self.scraper = StudentVueScraper(domain: domain, username: username, password: password)
    }

    public func updateCredentials(domain: String? = nil, username: String? = nil, password: String? = nil) {
        if let domain = domain {
            StudentVue.domain = domain
        }

        self.api.updateCredentials(domain: domain, username: username, password: password)
        self.scraper.updateCredentials(domain: domain, username: username, password: password)
    }
}
