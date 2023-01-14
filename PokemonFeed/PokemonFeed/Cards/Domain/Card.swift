//
//  Card.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public struct Card: Hashable {
    public let id: String
    public let name: String
    public let supertype: SuperType
    public let number: String
    public let rarity: String?
    public let flavorText: String?
    public let legalities: Legalities
    public let artist: String?
    public let cardmarket: CardMarket?
    public let images: CardImages?
    public let cardSet: CardSet
    
    public init(id: String, name: String, supertype: SuperType, number: String, rarity: String?, flavorText: String?, legalities: Legalities, artist: String?, cardmarket: CardMarket?, images: CardImages?, cardSet: CardSet) {
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

public struct CardMarket: Hashable {
    public let url: URL
    public let updatedAt: Date
    public let prices: CardPrice
    
    public init(url: URL, updatedAt: Date, prices: CardPrice) {
        self.url = url
        self.updatedAt = updatedAt
        self.prices = prices
    }
}

public struct CardImages: Hashable {
    public let small: URL
    public let large: URL
    
    public init(small: URL, large: URL) {
        self.small = small
        self.large = large
    }
}

public struct CardPrice: Hashable {
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

public struct CardSet: Hashable {
    public let id: String
    public let name: String
    public let series: String
    
    public init(id: String, name: String, series: String) {
        self.id = id
        self.name = name
        self.series = series
    }
}
