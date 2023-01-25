//
//  ValidateBoosterSetsCacheUseCaseTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import XCTest
import PokemonFeed

class ValidateBoosterSetCacheUseCaseTests: XCTestCase {
    func test_init_doesNotBoosterSetStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedBoosterSets, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        store.completeRetrieval(with: anyNSError())
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedBoosterSets, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()

        try? sut.validateCache()
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteNonExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        try? sut.validateCache()
        store.completeRetrieval(with: boosterSets.local, timestamp: nonExpiredTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_validateCache_deletesCacheOnExpiration() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        store.completeRetrieval(with: boosterSets.local, timestamp: expirationTimestamp)
        try? sut.validateCache()
        
        XCTAssertEqual(store.receivedBoosterSets, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_deletesExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        store.completeRetrieval(with: boosterSets.local, timestamp: expiredTimestamp)
        try? sut.validateCache()
       
        XCTAssertEqual(store.receivedBoosterSets, [.retrieve, .deleteCachedFeed])
    }

    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletion(with: deletionError)
        })
    }

    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletionSuccessfully()
        })
    }

    func test_validateCache_succeedsOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }

    func test_validateCache_succeedsOnNonExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: boosterSets.local, timestamp: nonExpiredTimestamp)
        })
    }

    func test_validateCache_failsOnDeletionErrorOfExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let deletionError = anyNSError()

        expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrieval(with: boosterSets.local, timestamp: expiredTimestamp)
            store.completeDeletion(with: deletionError)
        })
    }

    func test_validateCache_succeedsOnSuccessfulDeletionOfExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: boosterSets.local, timestamp: expiredTimestamp)
            store.completeDeletionSuccessfully()
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalBoosterSetLoader, store: BoosterSetStoreSpy) {
        let store = BoosterSetStoreSpy()
        let sut = LocalBoosterSetLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalBoosterSetLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        let receivedResult = Result { try sut.validateCache() }
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
