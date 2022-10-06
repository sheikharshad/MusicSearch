//
//  APIBuilder.swift
//  Market Place
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation

typealias HTTPErrorMessage = String
typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
    case options = "OPTIONS"
    case head = "HEAD"
}

protocol APIBuilder {
    func urlRequest() throws -> URLRequest
    var baseURL: String { get }
    var path: String { get }
    var subPath: String? { get }
    var query: [String: String] { get }
    var method: HttpMethod { get }
    func body() throws -> Data?
}

extension APIBuilder {

    func urlRequest() throws -> URLRequest {
        let param = queryString
        let url = ["https:/", baseURL, path, subPath].compactMap({$0}).joined(separator: "/") +
        (param.isEmpty ? "" : "?" + param)
        guard let url = URL(string: url) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    var queryString: String {
        query.reduce("", {
            "\($0)&\($1.key)=\($1.value.encoded ?? "")"
        })
    }
}
