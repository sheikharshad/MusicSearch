//
//  MockResponseBuilder.swift
//  CarrefourTests
//
//  Created by Arshad shaikh on 05/10/2022.

import Foundation

struct MockResponseBuilder {

    typealias Builder = (URLRequest) -> (Response)

    static func failure(_ error: NSError) -> Builder {
        return { _ in return .failure(error) }
    }

    static func http(_ status: Int = 200,
                     headers: [String: String]? = nil,
                     download: Download = .noContent) -> Builder {
        return { (request: URLRequest) in
            if let url = request.url,
               let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: headers) {
                return Response.success(response, download)
            }

            return .failure(NSError(domain: NSExceptionName.internalInconsistencyException.rawValue,
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "Failed to construct response for stub."]))
        }
    }
    static func requestAnalyser(_ status: Int = 200,
                                headers: [String: String]? = nil,
                                onRequest: @escaping (URLRequest) -> Void) -> Builder {
        return { (request: URLRequest) in
            let dictionary = ["url": request.url!.absoluteString,
                              "header": request.allHTTPHeaderFields ?? [:]] as [String: Any]
            let data = try? JSONSerialization.data(withJSONObject: dictionary,
                                                   options: JSONSerialization.WritingOptions())
            onRequest(request)
            return http(status, headers: headers, download: .content(data!))(request)
        }
    }

    static func jsonResponseFromFile(file: JsonFileNameType,
                                     status: Int = 200,
                                     headers: [String: String]? = nil) -> Builder {
        let data = try? JSONUtility().dataFromBundle(file: file)
        return jsonData(data)
    }

    static func jsonData(_ data: Data?, status: Int = 200, headers: [String: String]? = nil) -> Builder {
        return { (request: URLRequest) in
            var headers = headers ?? [String: String]()
            if headers["Content-Type"] == nil {
                headers["Content-Type"] = "application/json; charset=utf-8"
            }
            var content = Download.noContent
            if let data = data {
                content = .content(data)
            }
            return http(status, headers: headers, download: content)(request)
        }
    }
}
