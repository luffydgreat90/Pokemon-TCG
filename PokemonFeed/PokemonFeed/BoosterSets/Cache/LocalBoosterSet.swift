//
//  LocalBoosterSet.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public struct LocalBoosterSet: Equatable {
    public let id: String
    public let name: String
    public let series: String
    public let printedTotal: Int
    public let total: Int
    public let legalities: LocalLegalities
    public let releaseDate: Date
    public let images: LocalImages
    
    init(id: String, name: String, series: String, printedTotal: Int, total: Int, legalities: LocalLegalities, releaseDate: Date, images: LocalImages) {
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

public struct LocalImages: Equatable {
    public let symbol: URL
    public let logo: URL
    
    init(symbol: URL, logo: URL) {
        self.symbol = symbol
        self.logo = logo
    }
}
