//
//  BoosterSet.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public struct BoosterSet: Hashable {
    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let legalities: BoosterLegalities
    let releaseDate: Date
    let images: BoosterImage
    
    public init(id: String, name: String, series: String, printedTotal: Int, total: Int, legalities: BoosterLegalities, releaseDate: Date, images: BoosterImage) {
        self.id = id
        self.name = name
        self.series = series
        self.printedTotal = printedTotal
        self.total = total
        self.legalities = legalities
        self.releaseDate = releaseDate
        self.images = images
    }
}

public struct BoosterLegalities: Hashable {
    let isUnlimited: Bool
    let isStandard: Bool
    let isExpanded: Bool
    
    public init(isUnlimited: Bool, isStandard: Bool, isExpanded: Bool) {
        self.isUnlimited = isUnlimited
        self.isStandard = isStandard
        self.isExpanded = isExpanded
    }
}

public struct BoosterImage: Hashable {
    let symbol: URL
    let logo: URL
    
    public init(symbol: URL, logo: URL) {
        self.symbol = symbol
        self.logo = logo
    }
}
