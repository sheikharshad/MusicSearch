//
//  MusicSearch.swift
//  MusicSearchTests
//
//  Created by Arshad shaikh on 05/10/2022.
//

import XCTest
@testable import MusicSearch

class MusicSearchTest: XCTestCase {
    override func setUp() {
        stub(MockMatcher.mock(regex: ".*method=album.search.*"),
             MockResponseBuilder.jsonResponseFromFile(file: .testJson(file: .mockSearch)))
        stub(MockMatcher.mock(regex: ".*method=album.info.*"),
             MockResponseBuilder.jsonResponseFromFile(file: .testJson(file: .mockDetail)))
    }

    func testSearch() throws {
        let expectation: XCTestExpectation = .init(description: "testSearch")
        let keyword = "believe"
        let viewModel = AlbumSearchViewModel(searchRepo: SearchRepository())
        let cancelbag = CancelBag()
        viewModel.needReload.sink {
            if $0 {
                let model = viewModel.item(at: 0) as! AlbumListModel  // swiftlint:disable:this force_cast
                XCTAssertEqual(model.album, "Do You Believe in Gosh?")
                XCTAssertEqual(model.artist, "Mitch Hedberg")
                XCTAssertEqual(model.mbID, "06022c49-c941-472e-9b86-9c11aa250bf9")
                XCTAssertEqual(model.link, "https://www.last.fm/music/Mitch+Hedberg/Do+You+Believe+in+Gosh%3F")
                expectation.fulfill()
            }
        }.store(in: cancelbag)
        viewModel.keyword.value = keyword
        wait(for: [expectation], timeout: 10)
    }
}
