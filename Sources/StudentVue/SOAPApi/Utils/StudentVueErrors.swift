//
//  ApiErrors.swift
//  StudentVue
//
//  Created by Peter Duanmu on 4/11/23.
//

import Foundation

extension StudentVueApi {
    /// Custom error messages that the methods within ``StudentVueApi`` can throw.
    public enum StudentVueErrors: LocalizedError {
        /// Requested endpoint url is unreachable.
        case unreachableURL(String)

        /// Response returned by StudentVue API was empty or unable to be converted to type `Data`.
        case emptyResponse

        /// Username passed is empty.
        case noUsername

        /// Password passed is empty.
        case noPassword

        /// Credentials passed in are invalid.
        case invalidCredentials

        /// A miscellaneous SOAP API error has occured.
        case soapError(String)
    }
}

extension StudentVueApi.StudentVueErrors {
    /// Provides localization for the custom error messages.
    public var errorDescription: String? {
        switch self {
        case .unreachableURL(let string):
            return "Unable to reach domain: \(string)"
        case .emptyResponse:
            return "Empty response body"
        case .noUsername:
            return "No username provided"
        case .noPassword:
            return "No password provided"
        case .invalidCredentials:
            return "Invalid user id or password"
        case .soapError(let string):
            return "Soap request returned error: \(string)"
        }
    }
}
