//
//  BoosterSetsLocalizationTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import XCTest
import PokemonFeed

class BoosterSetsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "BoosterSets"
        let bundle = Bundle(for: BoosterSetsPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
