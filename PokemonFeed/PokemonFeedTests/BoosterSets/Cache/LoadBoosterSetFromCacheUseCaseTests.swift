//
//  LoadBoosterSetFromCacheUseCaseTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import XCTest
import PokemonFeed

class LoadBoosterSetFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedBoosterSets, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        _ = try? sut.load()

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_load_deliversNoBoosterSetsOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }

    func test_load_deliversCachedBoosterSetsOnNonExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success(boosterSets.models), when: {
            store.completeRetrieval(with: boosterSets.local, timestamp: nonExpiredTimestamp)
        })
    }

    func test_load_deliversNoBoosterSetsOnCacheExpiration() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: boosterSets.local, timestamp: expirationTimestamp)
        })
    }

    func test_load_deliversNoBoosterSetsOnExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrieval(with: boosterSets.local, timestamp: expiredTimestamp)
        })
    }

    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()

        _ = try? sut.load()
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()

        _ = try? sut.load()
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        _ = try? sut.load()
        store.completeRetrieval(with: boosterSets.local, timestamp: nonExpiredTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        _ = try? sut.load()
        store.completeRetrieval(with: boosterSets.local, timestamp: expirationTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        _ = try? sut.load()
        store.completeRetrieval(with: boosterSets.local, timestamp: expiredTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalBoosterSetLoader, store: BoosterSetStoreSpy) {
        let store = BoosterSetStoreSpy()
        
        let sut = LocalBoosterSetLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalBoosterSetLoader, toCompleteWith expectedResult: Result<[BoosterSet], Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        let receivedResult = Result { try sut.load() }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedImages), .success(expectedImages)):
            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
