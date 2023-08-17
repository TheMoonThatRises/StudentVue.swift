//
//  ApiErrors.swift
//
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation

extension StudentVueApi {
    public enum StudentVueErrors: LocalizedError {
        case unreachableURL(String)
        case emptyResponse
        case clientNotIntialised
        case noUsername
        case noPassword
        case soapError(String)
    }
}

extension StudentVueApi.StudentVueErrors {
    public var errorDescription: String? {
        switch self {
        case .unreachableURL(let string):
            return "Unable to reach domain: \(string)"
        case .emptyResponse:
            return "Empty response body"
        case .clientNotIntialised:
            return "StudentVue client has not been created"
        case .noUsername:
            return "No username provided"
        case .noPassword:
            return "No password provided"
        case .soapError(let string):
            return "Soap request returned error: \(string)"
        }
    }
}
