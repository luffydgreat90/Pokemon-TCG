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
    
    func test_boosterSetSelection_notifiesHandler() {
        let boosterSet1 = makeBoosterSet()
        let boosterSet2 = makeBoosterSet()
        var selectedImages = [BoosterSet]()
        
        let (sut, loader) = makeSUT(selection: { selectedImages.append($0) })

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [boosterSet1, boosterSet2], at: 0)

        sut.simulateTapOnFeedImage(at: 0)
        XCTAssertEqual(selectedImages, [boosterSet1])

        sut.simulateTapOnFeedImage(at: 1)
        XCTAssertEqual(selectedImages, [boosterSet1, boosterSet2])
    }
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadBoosterSetCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadBoosterSetCallCount, 1, "Expected a loading request once view is loaded")
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
    
    func makeBoosterSet() -> BoosterSet {
        let id = UUID().uuidString
        return BoosterSet(
            id: id,
            name: "Booster \(id)",
            series: "Series \(id)",
            printedTotal: 1,
            total: 1,
            legalities: Legalities(isUnlimited: true, isStandard: true, isExpanded: true),
            releaseDate: Date(),
            images: BoosterImage(symbol: anyURL(), logo: anyURL()))
    }
    
}
