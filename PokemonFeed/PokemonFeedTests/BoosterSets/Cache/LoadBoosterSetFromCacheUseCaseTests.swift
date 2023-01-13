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

        sut.load { _ in }

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

        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()

        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnNonExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: boosterSets.local, timestamp: nonExpiredTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnCacheExpiration() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: boosterSets.local, timestamp: expirationTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_hasNoSideEffectsOnExpiredCache() {
        let boosterSets = uniqueBoosterSets()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load { _ in }
        store.completeRetrieval(with: boosterSets.local, timestamp: expiredTimestamp)

        XCTAssertEqual(store.receivedBoosterSets, [.retrieve])
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = BoosterSetStoreSpy()
        var sut: LocalBoosterSetLoader? = LocalBoosterSetLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalBoosterSetLoader.LoadResult]()
        sut?.load { receivedResults.append($0) }

        sut = nil
        store.completeRetrievalWithEmptyCache()

        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalBoosterSetLoader, store: BoosterSetStoreSpy) {
        let store = BoosterSetStoreSpy()
        
        let sut = LocalBoosterSetLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalBoosterSetLoader, toCompleteWith expectedResult: LocalBoosterSetLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedBoosterSets), .success(expectedBoosterSets)):
                XCTAssertEqual(receivedBoosterSets, expectedBoosterSets, file: file, line: line)

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
