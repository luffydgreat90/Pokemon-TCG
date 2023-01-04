//
//  BoosterSetCacheTestHelpers.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }

    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
