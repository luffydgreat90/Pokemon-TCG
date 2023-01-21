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
    
    func test_retrieveImageData_inserteData() {
        let sut = makeSUT()
        let storedData = Data("first".utf8)

        let url = URL(string: "http://a-url.com")!

        insert(storedData, for: url, into: sut)
    
        self.expect(sut, toCompleteRetrievalWith: self.found(storedData), for: url)
    }
    

    // - MARK: Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataStore<CoreDataBoosterSetStore> {
        let storeURL = URL(fileURLWithPath: "/dev/null")
      
        let sut = try! CoreDataStore(storeURL: storeURL, store: CoreDataBoosterSetStore.self)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> Result<Data?, Error> {
        return .success(.none)
    }
    
    private func found(_ data: Data) -> Result<Data?, Error> {
        return .success(data)
    }
    
    private func localBoosterSet(url: URL) -> LocalBoosterSet {
        return LocalBoosterSet(id: "any", name: "any", series: "any", printedTotal: 1, total: 1, legalities: LocalLegalities(isUnlimited: true, isStandard: false, isExpanded: false), releaseDate: Date(), images: LocalImages(symbol: url, logo: anyURL()))
    }
    
    private func expect(_ sut: CoreDataStore<CoreDataBoosterSetStore>, toCompleteRetrievalWith expectedResult: Result<Data?, Error>, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        let receivedResult = Result { try sut.retrieve(dataForURL: url) }
        
        switch (receivedResult, expectedResult) {
        case let (.success( receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
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
                do {
                    try sut.insert(data, for: url)
                }catch {
                    XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
                }
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
}

