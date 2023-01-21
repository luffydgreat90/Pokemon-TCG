//
//  CacheImageDataUseCaseTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/8/23.
//

import XCTest
import PokemonFeed

class CacheImageDataUseCaseTests: XCTestCase {
    func test_init_doesNotImageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertTrue(store.receivedImages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()

        try? sut.save(data, for: url)

        XCTAssertEqual(store.receivedImages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: failed(), when: {
            
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalImageDataLoader, store: ImageDataStoreSpy) {
        let store = ImageDataStoreSpy()
        let sut = LocalImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> Result<Void, Error> {
        return .failure(LocalImageDataLoader.SaveError.failed)
    }
    
    private func expect(_ sut: LocalImageDataLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()
        let receivedResult = Result { try sut.save(anyData(), for: anyURL()) }
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case (.failure(let receivedError as LocalImageDataLoader.SaveError),
              .failure(let expectedError as LocalImageDataLoader.SaveError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
