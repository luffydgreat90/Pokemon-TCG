//
//  BoosterSet.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public struct BoosterSet: Hashable {
    public let id: String
    public let name: String
    public let series: String
    public let printedTotal: Int
    public let total: Int
    public let legalities: Legalities
    public let releaseDate: Date
    public let images: BoosterImage
    
    public init(id: String, name: String, series: String, printedTotal: Int, total: Int, legalities: Legalities, releaseDate: Date, images: BoosterImage) {
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

public struct BoosterImage: Hashable {
    public let symbol: URL
    public let logo: URL
    
    public init(symbol: URL, logo: URL) {
        self.symbol = symbol
        self.logo = logo
    }
}
