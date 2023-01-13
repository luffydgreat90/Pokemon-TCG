//
//  LoadCardFromCacheUseCaseTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import XCTest
import PokemonFeed

class LoadCardFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedCards, [])
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCardLoader, store: CardStoreSpy) {
        let store = CardStoreSpy()
        
        let sut = LocalCardLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
}
