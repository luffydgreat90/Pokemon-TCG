//
//  BoosterSetUIIntegrationTests.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import XCTest
import UIKit
import PokemonTCG
import PokemonFeed
import PokemoniOS
import Combine

class BoosterSetUIIntegrationTests: XCTestCase {
    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, boosterSetsTitle)
    }
    
    // MARK: - Helpers

    private func makeSUT(
        selection: @escaping (BoosterSet) -> Void = { _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = BoosterSetsUIComposer.boosterSetsComposedWith(
            boosterSetsLoader: loader.loadPublisher,
            imageLoader: loader.loadImageDataPublisher(from:),
            selection: selection)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
}
