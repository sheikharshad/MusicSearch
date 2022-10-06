//
//  MockingProtocol.swift
//  CarrefourTests
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation
import XCTest

extension XCTestCase {
  // matcher and biulder to add the stub
    func stub(_ matcher: @escaping MockMatcher.Matcher,
              delay: TimeInterval? = nil,
              _ builder: @escaping MockResponseBuilder.Builder) {
        MockingProtocol.addStub(matcher: matcher, delay: delay, builder: builder)
    }

    func removeAllStubs() {
        MockingProtocol.removeAllStub()
    }
}

final class MockingProtocol: URLProtocol {
    // MARK: Stubs
    fileprivate static let stub = StubDataSource.sharedStub
    fileprivate var enableDownloading = true
    fileprivate let operationQueue = OperationQueue()

    class func addStub(matcher: @escaping MockMatcher.Matcher,
                       delay: TimeInterval? = nil,
                       builder: @escaping MockResponseBuilder.Builder) {
        URLProtocol.registerClass(MockingProtocol.self)
        stub.addStubMatcher(matcher, delay: delay, builder: builder)
    }

    class func removeAllStub() {
        stub.removeAllStubs()
    }
    /// Returns whether there is a registered stub handler for the given request.
    override  class func canInit(with request: URLRequest) -> Bool {
        let canHandle = stub.stubForRequest(request) != nil
        return canHandle
    }

    override  class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let stub = Self.stub.stubForRequest(request) {
            let response = stub.builder(request)
            if let delay = stub.delay {
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + delay) {
                    self.sendResponse(response)
                }
            } else {
                sendResponse(response)
            }
        } else {
            let error = NSError(domain: NSExceptionName.internalInconsistencyException.rawValue,
                                code: 0,
                                userInfo: [ NSLocalizedDescriptionKey: "Handling request without a matching stub." ])
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        self.enableDownloading = false
        self.operationQueue.cancelAllOperations()
    }

    // MARK: Private Methods

    fileprivate func sendResponse(_ response: Response) {
        switch response {
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        case .success(var response, let download):
            let headers = self.request.allHTTPHeaderFields

            switch download {
            case .content(var data):
                applyRangeFromHTTPHeaders(headers, toData: &data, andUpdateResponse: &response)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            case .streamContent(data: var data, inChunksOf: let bytes):
                applyRangeFromHTTPHeaders(headers, toData: &data, andUpdateResponse: &response)
                self.download(data, inChunksOfBytes: bytes)
                return
            case .noContent:
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocolDidFinishLoading(self)
            }
        }
    }

    fileprivate func download(_ data: Data?, inChunksOfBytes bytes: Int) {
        guard let data = data else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        self.operationQueue.maxConcurrentOperationCount = 1
        self.operationQueue.addOperation { () -> Void in
            self.download(data, fromOffset: 0, withMaxLength: bytes)
        }
    }

    fileprivate func download(_ data: Data,
                              fromOffset offset: Int,
                              withMaxLength maxLength: Int) {
        guard let queue = OperationQueue.current else {
            return
        }
        guard offset < data.count else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        let length = min(data.count - offset, maxLength)

        queue.addOperation { () -> Void in
            guard self.enableDownloading else {
                self.enableDownloading = true
                return
            }

            let subdata = data.subdata(in: offset ..< (offset + length))
            self.client?.urlProtocol(self, didLoad: subdata)
            Thread.sleep(forTimeInterval: 0.01)
            self.download(data, fromOffset: offset + length, withMaxLength: maxLength)
        }
    }

    fileprivate func extractRangeFromHTTPHeaders(_ headers: [String: String]?) -> Range<Int>? {
        guard let rangeStr = headers?["Range"] else {
            return nil
        }
        let range = rangeStr.components(separatedBy: "=")[1].components(separatedBy: "-").map({ (str) -> Int in
            Int(str)!
        })
        let loc = range[0]
        let length = range[1] + 1
        return loc ..< length
    }

    fileprivate func applyRangeFromHTTPHeaders(
        _ headers: [String: String]?,
        toData data:inout Data,
        andUpdateResponse response:inout URLResponse) {
        guard let range = extractRangeFromHTTPHeaders(headers) else {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            return
        }

        let fullLength = data.count
        data = data.subdata(in: range)

        // Attach new headers to response
        if let serverResponse = response as? HTTPURLResponse,
           var header = serverResponse.allHeaderFields as? [String: String],
           let url = serverResponse.url {
            header["Content-Length"] = String(data.count)
            header["Content-Range"] = "bytes \(range.lowerBound)-\(range.upperBound)/\(fullLength)"
            if let httpResponse = HTTPURLResponse(url: url,
                                                  statusCode: serverResponse.statusCode,
                                                  httpVersion: nil,
                                                  headerFields: header) {
                response = httpResponse
            }
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
}
