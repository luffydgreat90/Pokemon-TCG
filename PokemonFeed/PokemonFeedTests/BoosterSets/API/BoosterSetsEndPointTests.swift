//
//  BoosterSetsEndPointTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import XCTest
import PokemonFeed

class BoosterSetsEndPointTests: XCTestCase {
    func test_boosterSet_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = BoosterSetsEndPoint.get().url(baseURL: baseURL)
    
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v2/sets", "path")
        XCTAssertEqual(received.query?.contains("pageSize=\(BoosterSetsEndPoint.pageSize)"), true, "query")
        XCTAssertEqual(received.query?.contains("page=1"), true, "query")
    }
    
    func test_boosterSet_endpointURL_withContents(){
        let baseURL = URL(string: "http://base-url.com")!

        let received = BoosterSetsEndPoint.get(totalItems: 20).url(baseURL: baseURL)
    
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v2/sets", "path")
        XCTAssertEqual(received.query?.contains("pageSize=\(BoosterSetsEndPoint.pageSize)"), true, "query")
        XCTAssertEqual(received.query?.contains("page=3"), true, "query")
    }
}
