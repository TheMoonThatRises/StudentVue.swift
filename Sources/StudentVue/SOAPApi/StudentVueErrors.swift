//
//  ApiErrors.swift
//
//
//  Created by TheMoonThatRises on 4/11/23.
//

import Foundation

enum StudentVueErrors: LocalizedError {
    case unreachableURL(String)
    case emptyResponse
    case clientNotIntialised
    case soapError(String)
}

extension StudentVueErrors {
    var errorDescription: String? {
        switch self {
        case .unreachableURL(let string):
            return "Unable to reach domain: \(string)"
        case .emptyResponse:
            return "Empty response body"
        case .clientNotIntialised:
            return "StudentVue client has not been created"
        case .soapError(let string):
            return "Soap request returned error: \(string)"
        }
    }
}
