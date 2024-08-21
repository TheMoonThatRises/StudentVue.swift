//
//  StudentVue.swift
//  
//
//  Created by TheMoonThatRises on 8/9/23.
//

import Foundation

/// Class representing StudentVue api access instance.
///
/// Contains access points for both the ``StudentVueApi`` and ``StudentVueScraper``, which can be
/// used to interact with the StudentVue api or website.
///
/// Information required to login and access information can set using the
/// ``init(domain:username:password:)`` initializer. Inputted credentials can then be checked with
/// ``checkCredentials()``.
///
/// ```swift
/// let client = StudentVue(domain: "test.edupoint.com",
///                         username: "970011111",
///                         password: "password")
///
/// do {
///     let isValidCredentials = try await client.checkCredentials()
/// } catch {
///     fatalError(String(describing: error))
/// }
/// ```
public class StudentVue {
    /// Official StudentVue api endpoint.
    public private(set) var api: StudentVueApi
    /// StudentVue website scraper.
    public private(set) var scraper: StudentVueScraper
    /// StudentVue connection domain.
    public private(set) static var domain = ""

    /// Initializes a new StudentVue client with user credientials.
    ///
    /// This initializers also initialize and store ``StudentVueApi`` and ``StudentVueScraper``.
    ///
    /// - Parameters:
    ///   - domain: Domain of StudentVue the school uses.
    ///   - username: The username of the account.
    ///   - password: The password of the account.
    public init(domain: String, username: String, password: String) {
        StudentVue.domain = domain
        self.api = StudentVueApi(domain: domain, username: username, password: password)
        self.scraper = StudentVueScraper(domain: domain, username: username, password: password)
    }

    /// Retrieves account details as a hash.
    ///
    /// Since the username and password are inaccessible once set, this provides a way to check for
    /// account similarities.
    ///
    /// The hash is created by joining the username, password, and domain and using `SHA256` to
    /// generate a one-way hash.
    ///
    /// - Returns: Hash of joined username, password, and domain.
    public func getAccountHash() -> String {
        return api.getAccountHash()
    }

    /// Updates the credentials of the user.
    ///
    /// As a convience, the domain, username, and password can be updated individually. This method
    /// will cascade down and update the credentials for ``StudentVueApi`` and
    /// ``StudentVueScraper``.
    ///
    /// ```swift
    /// client.updateCredentials(password: "my new password")
    /// ```
    ///
    /// - Parameters:
    ///   - domain: The new domain.
    ///   - username: The new username.
    ///   - password: The new password.
    public func updateCredentials(domain: String? = nil, username: String? = nil, password: String? = nil) {
        if let domain = domain {
            StudentVue.domain = domain
        }

        self.api.updateCredentials(domain: domain, username: username, password: password)
        self.scraper.updateCredentials(domain: domain, username: username, password: password)
    }

    /// Checks validity of user credentials.
    ///
    /// This method tests the validity of the combination of username, password, and domain by
    /// attempting to access the student's uploaded sound file. The API will return a response with
    /// an error code that is then caught and returned as a boolean here.
    ///
    /// Accessing the student's sound file is the fastest verification method, with only a 0.7 second
    /// wait time.
    ///
    /// - Throws: `Error` some other error has occured when api request was sent/
    ///
    /// - Returns: If the credentials are valid.
    public func checkCredentials() async throws -> Bool {
        return try await api.checkCredentials()
    }
}
