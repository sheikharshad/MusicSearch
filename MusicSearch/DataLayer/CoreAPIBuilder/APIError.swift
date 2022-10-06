//
//  APIError.swift
//  Market Place
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation

enum APIError: Error {
    init(code: HTTPCode, message: HTTPErrorMessage? = nil) {
        self = .httpCode(code, message ?? "unknown")
    }
    case invalidURL
    case httpCode(HTTPCode, HTTPErrorMessage? = nil)
    case unexpectedResponse
    case decodingError(message: String)
    case unknown
    case disconnected
}

extension APIError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "malformed url"
        case .decodingError(let message):
            return "Failed to decode:-\(message)"
        case .httpCode(let code, let message):
            return "\(code) - \(message ?? "")"
        case .unknown:
            return "unknown"
        case .disconnected, .unexpectedResponse:
            return "disconnected"
        }
    }
}

func undefined<T>() -> T {
    fatalError("undefined")
}
