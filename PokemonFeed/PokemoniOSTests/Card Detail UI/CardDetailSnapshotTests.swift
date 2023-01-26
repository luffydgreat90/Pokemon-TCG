//
//  CardDetailSnapshotTests.swift
//  PokemoniOSTests
//
//  Created by Marlon Ansale on 1/26/23.
//

import XCTest
import PokemoniOS
@testable import PokemonFeed

final class CardDetailSnapshotTests: XCTestCase {
    
    func test_CardDetail() {
        let sut = makeSUT()
        
        sut.display(cardDetail())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CARD_DETAIL_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CARD_DETAIL_dark")
    }
    
    private func makeSUT() -> CardDetailViewController {
        let cardDetailViewController = CardDetailViewController()
        return cardDetailViewController
    }
    
    private func cardDetail() -> CardDetailViewModel {
        CardDetailViewModel(
            name: "Alakazam",
            supertype: "Pokemon",
            number: "1",
            artist: "John Doe",
            averageSellPrice: "$ 5.00",
            trendPrice: "$ 3.00",
            lowPrice: "$ 1.00",
            baseSetName: "Base",
            flavorText: "Flavor text")
    }
    
}
