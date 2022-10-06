//
//  MusicSearchRequestTest.swift
//  MusicSearchRequestTest
//
//  Created by Arshad shaikh on 05/10/2022.
//

import XCTest
@testable import MusicSearch

class MusicSearchRequestTest: XCTestCase {

    func testSearchRequest() throws {
    let expectation: XCTestExpectation = .init(description: "SearchRequest")
        let keyword = "believe"
            stub(MockMatcher.mock(regex: ".*method=album.search.*"),
                 MockResponseBuilder.requestAnalyser(onRequest: { request in
                guard let parameter = request.url?.params else {
                    XCTFail("invalid param")
                    return
                }
                XCTAssertEqual(parameter["limit"], "20")
                XCTAssertEqual(parameter["method"], "album.search")
                XCTAssertEqual(parameter["api_key"], "7ac604d3ca628eb9e3746c61f5620da5")
                XCTAssertEqual(parameter["page"], "1")
                XCTAssertEqual(parameter["album"], keyword)
                XCTAssertEqual(parameter["format"], "json")
                expectation.fulfill()
            }))
        let viewModel = AlbumSearchViewModel(searchRepo: SearchRepository())
        viewModel.keyword.value = keyword
        wait(for: [expectation], timeout: 10)
        removeAllStubs()
    }

    func testDetailRequest() throws {
    let expectation: XCTestExpectation = .init(description: "SearchRequest")
        let param = DetailParameter(album: "Believe", mbID: "06022c49-c941-472e-9b86-9c11aa250bf9", artist: "Cher")
            stub(MockMatcher.mock(regex: ".*info.*"), MockResponseBuilder.requestAnalyser(onRequest: { request in
                guard let parameter = request.url?.params else {
                    XCTFail("invalid param")
                    return
                }
                XCTAssertEqual(parameter["method"], "album.getinfo")
                XCTAssertEqual(parameter["api_key"], "7ac604d3ca628eb9e3746c61f5620da5")
                XCTAssertEqual(parameter["mbid"], param.mbID)
                XCTAssertEqual(parameter["album"], param.album)
                XCTAssertEqual(parameter["artist"], param.artist)
                XCTAssertEqual(parameter["format"], "json")
                expectation.fulfill()
            }))
        let viewModel = DetailViewModel()
        viewModel.search = DetailParameter(album: "Believe",
                                           mbID: "06022c49-c941-472e-9b86-9c11aa250bf9",
                                           artist: "Cher")
        viewModel.fetch()
        wait(for: [expectation], timeout: 10)
        removeAllStubs()
    }
}
