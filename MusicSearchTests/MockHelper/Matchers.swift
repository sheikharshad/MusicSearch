//
//  Matchers.swift
//  CarrefourTests
//
//  Created by Arshad shaikh on 05/10/2022.

import Foundation
struct MockMatcher {

    typealias Matcher = (URLRequest) -> (Bool)
    enum HTTPMethod: CustomStringConvertible {
        case get
        case post
        case patch
        case put
        case delete
        case options
        case head

        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .patch:
                return "PATCH"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            case .options:
                return "OPTIONS"
            case .head:
                return "HEAD"
            }
        }
    }

    static func mock(regex: String) -> Matcher {

        return { (request: URLRequest) in
            if let path = request.url?.absoluteString,
               path.range(of: regex, options: .regularExpression) != nil {
                return true
            }
            return false
        }
    }

    static func http(_ method: HTTPMethod, uri: String) -> Matcher {
        return { (request: URLRequest) in
            if let requestMethod = request.httpMethod,
                requestMethod == method.description {
                return mock(regex: uri)(request)
            }
            return false
        }
    }
}
