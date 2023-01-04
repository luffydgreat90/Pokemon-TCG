//
//  BoosterSetsPresenterTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import XCTest
import PokemonFeed

final class BoosterSetsPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(BoosterSetsPresenter.title, localized("BOOSTER_SET_TITLE"))
    }
    
    func test_map_createsViewModel() {
        let sets = uniqueBoosterSets()

        let viewModel = BoosterSetsPresenter.map(sets.models)

        XCTAssertEqual(viewModel.sets, sets.models)
    }
    
    // MARK: - Helpers
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "BoosterSets"
        let bundle = Bundle(for: BoosterSetsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}


