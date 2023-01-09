//
//  CardEndPointTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import XCTest
import PokemonFeed

class CardEndPointTests: XCTestCase {
    func test_feed_endpointURL() {
        let id = "base1"
        let baseURL = URL(string: "http://base-url.com/")!
        let received = CardEndPoint.get(id).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/cards?q=set.id:\(id)")!

        XCTAssertEqual(received.absoluteString, expected.absoluteString)
    }

}
