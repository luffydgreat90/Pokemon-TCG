//
//  CardPresenterTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/8/23.
//

import XCTest
import PokemonFeed

class CardPresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let card1 = uniqueCard(trendPrice: 1.0)
        let card2 = uniqueCard(trendPrice: 1.123)
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale =  Locale(identifier: "en_US_POSIX")
        
        let viewModel1 = CardPresenter.map(card1, currencyFormatter: currencyFormatter)
        
        XCTAssertEqual(viewModel1.name, card1.name)
        XCTAssertEqual(viewModel1.price, "$ 1.00")
        
        let viewModel2 = CardPresenter.map(card2, currencyFormatter: currencyFormatter)
        
        XCTAssertEqual(viewModel2.name, card2.name)
        XCTAssertEqual(viewModel2.price, "$ 1.12")
        
    }
}
