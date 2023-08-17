//
//  ScraperErrors.swift
//  
//
//  Created by TheMoonThatRises on 3/10/23.
//

import Foundation
extension StudentVueScraper {
    public enum ScraperErrors: Error {
        case emptyData
        case incorrectPassword
        case invalidUsername
        case noPassword
        case noUsername
        case noCredentials
        case responseNot200
        case unknown(message: String?)
    }
}

extension StudentVueScraper.ScraperErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyData:
            return "Unable to retrieve data"
        case .incorrectPassword:
            return "Incorrect password"
        case .invalidUsername:
            return "Invalid username"
        case .responseNot200:
            return "Error when retrieving website contents"
        case .noPassword:
            return "No password provided"
        case .noUsername:
            return "No username provided"
        case .noCredentials:
            return "No username or password provided"
        case .unknown(let message):
            return message ?? "An unknown error has occured"
        }
    }
}
