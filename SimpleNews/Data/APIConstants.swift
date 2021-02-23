//
//  APIConstants.swift
//
//  Created by Hai Le.
//  Copyright © 2020 Hai Le. All rights reserved.
//

import Foundation

protocol ErrorDisplayable {
    var errorMessage: String { get }
}

enum APIError: Error, Equatable {
    case noInternetConnection
    case invalidAPIError
    case invalidImageLink
    case jsonFormatError
}

/**
 Define the error message.
 */
extension APIError: ErrorDisplayable {
    var errorMessage: String {
        switch self {
        case .invalidAPIError:
            return "Invalid API"
        case .invalidImageLink:
            return "Invalid image link"
        case .jsonFormatError:
            return "JSON format error"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
