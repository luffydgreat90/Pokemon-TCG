//
//  DeckPresenterTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 2/3/23.
//

import XCTest
import PokemonFeed

class DeckPresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let deck = uniqueDeck()
        
        let viewModel = DeckPresenter.map([deck])
        XCTAssertEqual(deck.name, viewModel.decks.first!.name)
    }
}
