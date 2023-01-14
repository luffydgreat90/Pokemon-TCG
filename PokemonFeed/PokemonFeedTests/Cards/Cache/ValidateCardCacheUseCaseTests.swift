//
//  ValidateCardCacheUseCaseTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import XCTest
import PokemonFeed

class ValidateCardCacheUseCaseTests: XCTestCase {
    func test_init_doesNotCardsStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedCards, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        let setID = "base1"
        
        sut.validateCache(setId: setID) { _ in }
        store.completeRetrievalError(with: anyNSError(), setID: setID)

        XCTAssertEqual(store.receivedCards, [.retrieve(setID), .deleteCachedCard(setID)])
    }
    
    func test_validateCache_doesDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        let setID = "base1"
        
        sut.validateCache(setId: setID) { _ in }
        store.completeRetrievalWithEmptyCache(with: anyNSError(), setID: setID)

        XCTAssertEqual(store.receivedCards, [.retrieve(setID), .deleteCachedCard(setID)])
    }
    
    func test_validateCache_deletesCacheOnExpiration() {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let setID = "base1"
        let expirationTimestamp = fixedCurrentDate.minusCardCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.validateCache(setId: setID) { _ in }
       
        XCTAssertNoThrow(try? store.completeRetrieval(with: cards.local, setID: setID, timestamp: expirationTimestamp), "Booster Set ID not found \(setID)")
        

        XCTAssertEqual(store.receivedCards, [.retrieve(setID), .deleteCachedCard(setID)])
    }
    
    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        let setID = "base1"
        
        expect(sut, setID: setID, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrievalError(with: anyNSError(), setID: setID)
            store.completeDeletion(with: deletionError, setId: setID)
        })
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        let setID = "base1"
        
        expect(sut, setID: setID, toCompleteWith: .success(()), when: {
            store.completeRetrievalError(with: anyNSError(), setID: setID)
            store.completeDeletionSuccessfully(setId: setID)
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
    
    private func expect(_ sut: LocalCardLoader, setID: String, toCompleteWith expectedResult: LocalCardLoader.ValidationResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.validateCache(setId: setID) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break

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
