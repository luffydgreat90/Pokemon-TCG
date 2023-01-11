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
    
    func test_loadingListIndicator_isVisibleWhileLoadingCard() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeCardLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

        loader.completeCardLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
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
    
    func makeCard(name: String = "Abra", superType: SuperType = .pokemon, image:URL = anyURL()) -> Card {
        let id = UUID().uuidString
        return Card(
            id: id,
            name: name,
            supertype: superType,
            number: "1",
            rarity: "Common",
            flavorText: nil,
            legalities: Legalities(isUnlimited: true, isStandard: false, isExpanded: false),
            artist: nil,
            cardmarket: CardMarket(url: anyURL(), updatedAt: Date(), prices: CardPrice(averageSellPrice: 1.0, lowPrice: 1.0, trendPrice: 3.0, reverseHoloTrend: 5.0)),
            images: CardImages(small: image, large: anyURL()),
            cardSet: CardSet(id: id, name: "Base", series: "Base1"))
    }
    func makeBoosterSet(symbol:URL = anyURL()) -> BoosterSet {
        let id = UUID().uuidString
        return BoosterSet(
            id: id,
            name: "Booster \(id)",
            series: "Series \(id)",
            printedTotal: 1,
            total: 1,
            legalities: Legalities(isUnlimited: true, isStandard: true, isExpanded: true),
            releaseDate: Date(),
            images: BoosterImage(symbol: symbol, logo: anyURL()))
    }
}
