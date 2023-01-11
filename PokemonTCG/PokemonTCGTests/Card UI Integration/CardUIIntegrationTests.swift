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
    
    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, boosterSetsTitle)
    }
    
    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: CollectionListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CardListUIComposer.cardListComposedWith(
            cardList: loader.loadPublisher(),
            imageLoader: loader.loadImageDataPublisher(from:))
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
}
