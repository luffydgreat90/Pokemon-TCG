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

        let setID = "base1"
        _ = try? sut.load(setID: setID)
        
        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = LocalCardLoader.EmptyList()
        let setID = "base1"
        
        expect(sut, setID:setID, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError, setID: setID)
        })
    }
    
    func test_load_deliversNoCardsOnEmptyCacheError() {
        let (sut, store) = makeSUT()
        let retrievalError = LocalCardLoader.EmptyList()
        let setID = "base1"
        
        expect(sut, setID: setID, toCompleteWith: .failure(retrievalError), when: { [retrievalError] in
            store.completeRetrievalWithEmptyCache(with: retrievalError, setID: setID)
        })
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let setID = "base1"
        _ = try? sut.load(setID: setID)

        store.completeRetrieval(with: LocalCardLoader.EmptyList(), setID: setID)
        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_hasNoSideEffectsOnNonExpiredCache() throws {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let setID = "base1"
        let nonExpiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        _ = try? sut.load(setID: setID)
        XCTAssertNoThrow(try store.completeRetrieval(with: cards.local, setID: setID, timestamp: nonExpiredTimestamp))

        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() throws {
        let cards = uniqueCards()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusBoosterSetCacheMaxAge().adding(seconds: -1)
        let setID = "base1"
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        _ = try? sut.load(setID: setID)
        XCTAssertNoThrow(try store.completeRetrieval(with: cards.local, setID: setID, timestamp: expiredTimestamp))

        XCTAssertEqual(store.receivedCards, [.retrieve(setID)])
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
        
        let receivedResult = Result { try sut.load(setID: setID) }

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
