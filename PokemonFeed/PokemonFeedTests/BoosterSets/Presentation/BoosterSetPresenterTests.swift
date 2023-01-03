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

        let viewModel = BoosterSetPresenter.map(booster)
        XCTAssertEqual(viewModel.image, booster.images.logo)
        XCTAssertEqual(viewModel.title, booster.name)
    }
}
