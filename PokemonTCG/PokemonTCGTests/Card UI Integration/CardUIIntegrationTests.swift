//
//  CardUIIntegrationTests.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/11/23.
//

import XCTest
import UIKit
import PokemonTCG
import PokemonFeed
import PokemoniOS
import Combine

class CardUIIntegrationTests: XCTestCase {
    
    func test_loadFeedActions_requestCardsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCardCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCardCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCardCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCardCallCount, 3, "Expected yet another loading request once user initiates another reload")
        
    }
    
    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CollectionListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CardListUIComposer.cardListComposedWith(
            cardList:loader.loadPublisher,
            imageLoader: loader.loadImageDataPublisher(from:))
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}
