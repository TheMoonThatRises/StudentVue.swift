//
//  Hash.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/19/24.
//

import CryptoKit

/// Account hashing methods.
///
/// This is a convienance class that is used to convert the combination of username, password,
/// and domain into a hash string.
///
/// This method is only used and accessable by ``StudentVue/StudentVue/getAccountHash()``.
///
/// ```swift
/// let hash = AccountHasher.hash(username: "970011111",
///                               password: "password",
///                               domain: "test.edupoint.com")
/// ```
class AccountHasher {
    /// Hashs the username, password, and domain.
    ///
    /// This method joins the username, password, and domain and passes the string into `SHA256`
    /// to create the hash. `SHA256` is used for the best performance and security.
    ///
    /// - Parameters:
    ///    - username: Username to hash with.
    ///    - password: Password to hash with.
    ///    - domain: Domain to hash with.
    ///
    /// - Returns: Hashed combination of username, password, and domain.
    public static func hash(username: String, password: String, domain: String) -> String {
        if let data = (username + password + domain).data(using: .utf8) {
            let digest = SHA256.hash(data: data)

            let hashString = digest
                .compactMap { String(format: "%02x", $0) }
                .joined()

            return hashString
        } else {
            return ""
        }
    }
}
