//
//  Hash.swift
//  StudentVue
//
//  Created by TheMoonThatRises on 8/19/24.
//

import CryptoKit

class AccountHasher {
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
