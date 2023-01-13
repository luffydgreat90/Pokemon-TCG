//
//  BoosterSetCache+TestHelpers.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

extension Date {
    func minusBoosterSetCacheMaxAge() -> Date {
        return adding(days: -boosterSetCacheMaxAgeInDays)
    }
    
    private var boosterSetCacheMaxAgeInDays: Int {
        return 7
    }
}
