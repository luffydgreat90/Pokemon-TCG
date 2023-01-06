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
    public let types: [String]?
    public let number: String
    public let rarity: String?
    public let flavorText: String?
    public let nationalPokedexNumbers: [Int]?
    public let legalities: Legalities
    public let artist: String?
    public let cardmarket: CardMarket
    public let images: CardImages?
    public let cardSet: CardSet
    
    public init(id: String, name: String, supertype: SuperType, types: [String]?, number: String, rarity: String?, flavorText: String?, nationalPokedexNumbers: [Int]?, legalities: Legalities, artist: String?, cardmarket: CardMarket, images: CardImages?, cardSet: CardSet) {
        self.id = id
        self.name = name
        self.supertype = supertype
        self.types = types
        self.number = number
        self.rarity = rarity
        self.flavorText = flavorText
        self.nationalPokedexNumbers = nationalPokedexNumbers
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
    public let lowPriceExPlus: Double?
    public let avg1: Double?
    public let avg7: Double?
    public let avg30: Double?

    init(averageSellPrice: Double?, lowPrice: Double?, trendPrice: Double?, reverseHoloTrend: Double?, lowPriceExPlus: Double?, avg1: Double?, avg7: Double?, avg30: Double?) {
        self.averageSellPrice = averageSellPrice
        self.lowPrice = lowPrice
        self.trendPrice = trendPrice
        self.reverseHoloTrend = reverseHoloTrend
        self.lowPriceExPlus = lowPriceExPlus
        self.avg1 = avg1
        self.avg7 = avg7
        self.avg30 = avg30
    }
}

public enum SuperType {
    case trainer, energy, pokemon, unknown
    
    public static func checkSupertype(_ superType: String) -> SuperType {
        switch superType {
            case "Trainer": return .trainer
            case "Pokémon": return .pokemon
            case "Energy": return .energy
            default: return .unknown
        }
    }
}

public struct CardSet: Hashable {
    let id: String
    let name: String
    let series: String
}
