//
//  BoosterSetsEndPointTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import XCTest
import PokemonFeed

class BoosterSetsEndPointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = BoosterSetsEndPoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/sets")!

        XCTAssertEqual(received, expected)
    }
}
