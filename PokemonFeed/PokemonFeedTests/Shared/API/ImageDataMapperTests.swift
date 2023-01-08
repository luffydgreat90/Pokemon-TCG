//
//  ImageDataMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import XCTest
import PokemonFeed

final class ImageDataMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageDataMapper.map(anyData(), from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() {
        let emptyData = Data()

        XCTAssertThrowsError(
            try ImageDataMapper.map(emptyData, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversReceivedNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty data".utf8)

        let result = try ImageDataMapper.map(nonEmptyData, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, nonEmptyData)
    }
}
