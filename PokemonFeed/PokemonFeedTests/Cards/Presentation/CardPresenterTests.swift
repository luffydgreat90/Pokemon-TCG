//
//  CardPresenterTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/8/23.
//

import XCTest
import PokemonFeed

final class CardPresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let card = uniqueCard()
        
        let viewModel = CardPresenter.map(card)
        
        XCTAssertEqual(viewModel.name, card.name)
        XCTAssertEqual(viewModel.price, "$\(card.cardmarket.prices.trendPrice!)")
    }
    
}
