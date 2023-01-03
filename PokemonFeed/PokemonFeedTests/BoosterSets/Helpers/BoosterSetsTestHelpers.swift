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
        legalities: BoosterLegalities(isUnlimited: true, isStandard: true, isExpanded: true),
        releaseDate: Date(),
        images: BoosterImage(symbol: anyURL(), logo: anyURL()))
}

func uniqueBoosterSets() -> [BoosterSet] {
    let models = [uniqueBoosterSet(), uniqueBoosterSet()]
    return models
}
