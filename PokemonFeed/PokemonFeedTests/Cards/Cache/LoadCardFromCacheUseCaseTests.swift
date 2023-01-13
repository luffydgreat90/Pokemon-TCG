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

        sut.load(setID: "base1", completion: { _ in })

        XCTAssertEqual(store.receivedCards, [.retrieve("base1")])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        let setID = "base1"
        
        expect(sut, setID:setID, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrievalError(with: retrievalError, setID: setID)
        })
    }
    
    func test_load_deliversNoCardsOnEmptyCacheError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        let setID = "base1"
        
        expect(sut, setID: setID, toCompleteWith: .failure(retrievalError), when: { [retrievalError] in
            store.completeRetrievalWithEmptyCache(with: retrievalError, setID: setID)
        })
    }
    
    func test_load_deliversCachedBoosterSetsOnNonExpiredCache() throws {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let setID = "base1"
        let nonExpiredTimestamp = fixedCurrentDate.minusCardCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        expect(sut, setID: setID, toCompleteWith: .success(cards.models), when: {
            XCTAssertNoThrow(try store.completeRetrieval(with: cards.local, setID: setID, timestamp: nonExpiredTimestamp), "BoosterSet \(setID) not found ")
            
        })
    }

    func test_load_deliversNoCardsOnCacheExpirationError() {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusCardCacheMaxAge()
        let setID = "base1"
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, setID: setID, toCompleteWith: .failure(LocalCardLoader.EmptyList()), when: {
            try store.completeRetrieval(with: cards.local, setID: setID, timestamp: expirationTimestamp)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let setID = "base1"
        sut.load(setID: setID) { _ in }
        store.completeRetrievalError(with: anyNSError(), setID: setID)
        
        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_deliversNoBoosterSetsOnEmptyCache() {
        let (sut, store) = makeSUT()
        let setID = "base1"
        let retrievalError = anyNSError()
        
        expect(sut, setID: setID, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrievalWithEmptyCache(with: retrievalError, setID: setID)
        })
    }
    
    func test_load_hasNoSideEffectsOnNonExpiredCache() throws {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let setID = "base1"
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load(setID: setID) { _ in }
        XCTAssertNoThrow(try store.completeRetrieval(with: cards.local, setID: setID, timestamp: nonExpiredTimestamp))

        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_hasNoSideEffectsOnCacheExpiration() throws {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let setID = "base1"
        let expirationTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load(setID: setID)  { _ in }
        XCTAssertNoThrow(try store.completeRetrieval(with: cards.local, setID: setID, timestamp: expirationTimestamp))

        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() throws {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let setID = "base1"
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        sut.load(setID: setID) { _ in }
        XCTAssertNoThrow(try store.completeRetrieval(with: cards.local, setID: setID, timestamp: expiredTimestamp))

        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = CardStoreSpy()
        let setID = "base1"
        var sut: LocalCardLoader? = LocalCardLoader(store: store, currentDate: Date.init)

        var receivedResults = [LocalCardLoader.LoadResult]()
        sut?.load(setID: setID) { receivedResults.append($0) }

        sut = nil
        store.completeRetrievalWithEmptyCache(with: anyNSError(), setID: setID)

        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCardLoader, store: CardStoreSpy) {
        let store = CardStoreSpy()
        
        let sut = LocalCardLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalCardLoader,setID: String, toCompleteWith expectedResult: LocalCardLoader.LoadResult, when action: () throws -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load(setID: setID) { receivedResult in
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

        try? action()
        wait(for: [exp], timeout: 1.0)
    }
    
}
