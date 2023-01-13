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
    
    func test_load_requestsWithSetIdCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.load(setId: "base1", completion: { _ in })

        XCTAssertEqual(store.receivedCards, [.retrieve("base1")])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, setID: "base1", toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrievalError(with: retrievalError)
        })
    }
    
    func test_load_deliversNoCardsOnEmptyCacheError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, setID: "base1", toCompleteWith: .failure(retrievalError), when: { [retrievalError] in
            store.completeRetrievalWithEmptyCache(with: retrievalError)
        })
    }
    
    func test_load_deliversCachedBoosterSetsOnNonExpiredCache() {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let setID = "base1"
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, setID: setID, toCompleteWith: .success(cards.models), when: {
            store.completeRetrieval(with: cards.local, setID: setID, timestamp: nonExpiredTimestamp)
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCardLoader, store: CardStoreSpy) {
        let store = CardStoreSpy()
        
        let sut = LocalCardLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalCardLoader,setID: String, toCompleteWith expectedResult: LocalCardLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(setId: setID) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedCards), .success(expectedCards)):
                XCTAssertEqual(receivedCards, expectedCards, file: file, line: line)

            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
}
