//
//  CardCache+TestHelpers.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import Foundation

extension Date {
    func minusCardCacheMaxAge() -> Date {
        return adding(days: -cardCacheMaxAgeInDays)
    }
    
    private var cardCacheMaxAgeInDays: Int {
        return 14
    }
}
