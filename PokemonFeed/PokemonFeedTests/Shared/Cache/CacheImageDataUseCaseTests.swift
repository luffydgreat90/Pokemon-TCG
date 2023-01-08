//
//  CacheImageDataUseCaseTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/8/23.
//

import XCTest
import PokemonFeed

class CacheImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalImageDataLoader, store: ImageDataStoreSpy) {
        let store = ImageDataStoreSpy()
        let sut = LocalImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}
