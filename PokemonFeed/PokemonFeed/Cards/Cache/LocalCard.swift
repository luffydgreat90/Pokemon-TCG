//
//  LocalCard.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import Foundation

public struct LocalCard: Equatable {
    public let id: String
    public let name: String
    public let supertype: SuperType
    public let number: String
    public let rarity: String?
    public let flavorText: String?
    public let legalities: LocalLegalities
    public let artist: String?
    public let cardmarket: LocalCardMarket
    public let images: LocalCardImages?
    public let cardSet: LocalCardSet
    
    public init(id: String, name: String, supertype: SuperType, number: String, rarity: String?, flavorText: String?, legalities: LocalLegalities, artist: String?, cardmarket: LocalCardMarket, images: LocalCardImages?, cardSet: LocalCardSet) {
        self.id = id
        self.name = name
        self.supertype = supertype
        self.number = number
        self.rarity = rarity
        self.flavorText = flavorText
        self.legalities = legalities
        self.artist = artist
        self.cardmarket = cardmarket
        self.images = images
        self.cardSet = cardSet
    }
}

public struct LocalCardMarket: Hashable {
    public let url: URL
    public let updatedAt: Date
    public let prices: LocalCardPrice
    
    public init(url: URL, updatedAt: Date, prices: LocalCardPrice) {
        self.url = url
        self.updatedAt = updatedAt
        self.prices = prices
    }
}

public struct LocalCardImages: Hashable {
    public let small: URL
    public let large: URL
    
    public init(small: URL, large: URL) {
        self.small = small
        self.large = large
    }
}

public struct LocalCardPrice: Hashable {
    public let averageSellPrice: Double?
    public let lowPrice: Double?
    public let trendPrice: Double?
    public let reverseHoloTrend: Double?

    public init(averageSellPrice: Double?, lowPrice: Double?, trendPrice: Double?, reverseHoloTrend: Double?) {
        self.averageSellPrice = averageSellPrice
        self.lowPrice = lowPrice
        self.trendPrice = trendPrice
        self.reverseHoloTrend = reverseHoloTrend
    }
}

public struct LocalCardSet: Hashable {
    public let id: String
    public let name: String
    public let series: String
    
    public init(id: String, name: String, series: String) {
        self.id = id
        self.name = name
        self.series = series
    }
}
