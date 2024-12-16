//
//  ScraperErrors.swift
//  StudentVue
//
//  Created by Peter Duanmu on 3/10/23.
//

import Foundation
extension StudentVueScraper {
    /// Custom errors that methods within ``StudentVueScraper`` can throw.
    public enum ScraperErrors: Error {
        /// Returning data is empty.
        case emptyData

        /// The password inputted is invalid.
        case incorrectPassword

        /// The username inputted is invalid.
        case invalidUsername

        /// No password provided.
        case noPassword

        /// No username provided.
        case noUsername

        /// No credentials provided.
        case noCredentials

        /// Website did not return HTML code 200.
        case responseNot200

        /// HTML returned was unable to be parsed.
        case invalidWebsiteHTML

        /// An unknown error has occured.
        case unknown(message: String?)
    }
}

extension StudentVueScraper.ScraperErrors: LocalizedError {
    /// Provides localizations for custom error messages.
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
        case .invalidWebsiteHTML:
            return "Recieved invalid html from StudentVue website"
        case .unknown(let message):
            return message ?? "An unknown error has occured"
        }
    }
}
