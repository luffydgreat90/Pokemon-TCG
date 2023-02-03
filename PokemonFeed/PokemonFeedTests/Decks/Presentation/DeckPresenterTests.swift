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
        let dateFormat = DateFormatter.monthDayYear
        let viewModel = DeckPresenter.map(deck, dateFormatter: dateFormat)
        
        XCTAssertEqual(deck.name, viewModel.name)
        XCTAssertEqual(dateFormat.string(from: Date()), viewModel.update)
    }
}
