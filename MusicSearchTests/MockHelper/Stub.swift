//
//  StubDataSource.swift
//  CarrefourTests
//
//  Created by Arshad shaikh on 05/10/2022.
//

import Foundation

final class StubDataSource {

    static let sharedStub = StubDataSource()
    private var stubs = [Stub]()
    func addStub(_ stub: Stub) -> Stub {
        stubs.append(stub)
        return stub
    }
    /// Register a matcher and a builder as a new stub
     @discardableResult func addStubMatcher(_ matcher: @escaping MockMatcher.Matcher,
                                            delay: TimeInterval? = nil,
                                            builder: @escaping MockResponseBuilder.Builder) -> Stub {
        return addStub(Stub(matcher: matcher, delay: delay, builder: builder))
    }

    /// Unregister the given stub
    func removeStub(_ stub: Stub) {
        if let index = stubs.firstIndex(of: stub) {
            stubs.remove(at: index)
        }
    }

    /// Remove all registered stubs
    func removeAllStubs() {
        stubs.removeAll(keepingCapacity: false)
    }

    /// Finds the appropriate stub for a request
    /// This method searches backwards though the registered requests
    /// to find the last registered stub that handles the request.
    func stubForRequest(_ request: URLRequest) -> Stub? {
        for stub in stubs.reversed() {
            if stub.matcher(request) {
                return stub
            }
        }
        return nil
    }
}

extension StubDataSource {

    struct Stub: Equatable {
        static func == (lhs: StubDataSource.Stub, rhs: StubDataSource.Stub) -> Bool {
            return lhs.uuid == rhs.uuid
        }

        let matcher: MockMatcher.Matcher
        let delay: TimeInterval?
        let builder: MockResponseBuilder.Builder
        let uuid: UUID

        init(matcher:@escaping MockMatcher.Matcher,
             delay: TimeInterval?,
             builder: @escaping MockResponseBuilder.Builder) {
            self.matcher = matcher
            self.delay = delay
            self.builder = builder
            uuid = UUID()
        }
    }
}
