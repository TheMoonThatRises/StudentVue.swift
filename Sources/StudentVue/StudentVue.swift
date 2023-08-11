//
//  StudentVue.swift
//  
//
//  Created by TheMoonThatRises on 8/9/23.
//

import Foundation

class StudentVue {
    // Uses the official StudentVue api endpoint
    public let api: StudentVueApi
    // Scrapes the StudentVue website
    public let scraper: StudentVueScraper
    // Client domain for other files to use
    private static var interalDomain = ""
    public static var domain: String {
        get {
            StudentVue.interalDomain
        }
    }

    /// Initializes a new StudentVue client with user credientials
    ///
    /// - Parameters:
    ///   - domain: Domain of the school that uses StudentVue. Should be something like `something.edupoint.com`
    ///   - username: The username of the student's information to access
    ///   - password: The password of the student's information to access
    ///
    /// - Returns: A new StudentVue client with api and scraper
    init(domain: String, username: String, password: String) {
        StudentVue.interalDomain = domain
        self.api = StudentVueApi(domain: domain, username: username, password: password)
        self.scraper = StudentVueScraper(domain: domain, username: username, password: password)
    }
}
