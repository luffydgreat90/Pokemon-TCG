//
//  CoreDataBoosterSetImageDataStoreTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/8/23.
//

import XCTest
import PokemonFeed

final class CoreDataBoosterSetImageDataStoreTests: XCTestCase {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!

        insert(anyData(), for: url, into: sut)

        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        let url = URL(string: "http://a-url.com")!

        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)

        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: url)
    }
    
    func test_sideEffects_runSerially() {
        let sut = makeSUT()
        let url = anyURL()

        let op1 = expectation(description: "Operation 1")
        sut.insert([localBoosterSet(url: url)], timestamp: Date()) { _ in
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation 2")
        sut.insert(anyData(), for: url) { _ in op2.fulfill() }

        let op3 = expectation(description: "Operation 3")
        sut.insert(anyData(), for: url) { _ in op3.fulfill() }

        wait(for: [op1, op2, op3], timeout: 5.0, enforceOrder: true)
    }
    
    // - MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataStore<CoreDataBoosterSetStore> {
        let storeURL = URL(fileURLWithPath: "/dev/null")
      
        let sut = try! CoreDataStore(storeURL: storeURL, store: CoreDataBoosterSetStore.self)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> ImageDataStore.RetrievalResult {
        return .success(.none)
    }
    
    private func found(_ data: Data) -> ImageDataStore.RetrievalResult {
        return .success(data)
    }
    
    private func localBoosterSet(url: URL) -> LocalBoosterSet {
        return LocalBoosterSet(id: "any", name: "any", series: "any", printedTotal: 1, total: 1, legalities: LocalLegalities(isUnlimited: true, isStandard: false, isExpanded: false), releaseDate: Date(), images: LocalImages(symbol: url, logo: anyURL()))
    }
    
    private func expect(_ sut: CoreDataStore<CoreDataBoosterSetStore>, toCompleteRetrievalWith expectedResult: ImageDataStore.RetrievalResult, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.retrieve(dataForURL: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func insert(_ data: Data, for url: URL, into sut: CoreDataStore<CoreDataBoosterSetStore>, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache insertion")
        let boosterSet = localBoosterSet(url: url)
        sut.insert([boosterSet], timestamp: Date()) { result in
            switch result {
            case let .failure(error):
                XCTFail("Failed to save \(boosterSet) with error \(error)", file: file, line: line)
                exp.fulfill()

            case .success:
                sut.insert(data, for: url) { result in
                    if case let Result.failure(error) = result {
                        XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
                    }
                    exp.fulfill()
                }
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
}

