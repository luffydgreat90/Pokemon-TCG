//
//  BoosterSetsTestHelpers.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation
import PokemonFeed

func uniqueBoosterSet() -> BoosterSet {
    let id = UUID().uuidString
    return BoosterSet(
        id: id,
        name: "Booster \(id)",
        series: "Series \(id)",
        printedTotal: 1,
        total: 1,
        legalities: Legalities(isUnlimited: true, isStandard: true, isExpanded: true),
        releaseDate: Date(),
        images: BoosterImage(symbol: anyURL(), logo: anyURL()))
}

func uniqueBoosterSets() -> (models: [BoosterSet], local: [LocalBoosterSet]) {
    let models = [uniqueBoosterSet(), uniqueBoosterSet()]
    
    let locals = models.toLocal()
    
    return (models, locals)
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(minutes: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .minute, value: minutes, to: self)!
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
