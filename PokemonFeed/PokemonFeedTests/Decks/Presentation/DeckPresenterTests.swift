//
//  DeckPresenterTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 2/3/23.
//

import XCTest
import PokemonFeed

class DeckPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(DeckPresenter.title, localized("DECK_TITLE"))
    }
    
    func test_map_createsViewModel() {
        let deck = uniqueDeck()
        
        let viewModel = DeckPresenter.map([deck])
        XCTAssertEqual(deck.name, viewModel.decks.first!.name)
    }
    
    // MARK: - Helpers
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Decks"
        let bundle = Bundle(for: DeckPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
