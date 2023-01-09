//
//  BoosterSetPresenterTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import XCTest
import PokemonFeed

final class BoosterSetPresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let booster = uniqueBoosterSet()
        let dateFormat = DateFormatter.monthDayYear
        let viewModel = BoosterSetPresenter.map(booster, dateFormat: dateFormat)
        
        XCTAssertEqual(viewModel.title, booster.name)
        XCTAssertEqual(viewModel.totalCards, "Number of Cards: \(booster.total)")
        XCTAssertEqual(viewModel.releaseDate, dateFormat.string(from: Date()))
    }
}
