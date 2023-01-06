//
//  CardMapper.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public enum CardMapper {
    private struct Root: Decodable {
        let data: [RemoteCard]
    }
    
    private struct RemoteCard: Decodable {
        let id: String
        let name: String
        let supertype: String
        let types: [String]?
        let number: String
        let rarity: String?
        let flavorText: String?
        let nationalPokedexNumbers: [Int]?
        let legalities: RemoteLegalities
        let artist: String
        let cardmarket: RemoteCardMarket
        let images: RemoteImages
    }
    
    private struct RemoteImages: Decodable {
        let small: URL
        let large: URL
    }
    
    private struct RemoteLegalities: Decodable {
        let unlimited: String?
        let standard: String?
        let expanded: String?
    }
    
    private struct RemoteCardMarket: Decodable {
        let url: URL
        let updatedAt: Date
        let prices: RemotePrice
    }
    
    private struct RemotePrice: Decodable {
        let averageSellPrice: Double?
        let lowPrice: Double?
        let trendPrice: Double?
        let reverseHoloTrend: Double?
        let lowPriceExPlus: Double?
        let avg1: Double?
        let avg7: Double?
        let avg30: Double?
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Card] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yearMonthDay)
        
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.data.map {
            Card(
                id: $0.id,
                name: $0.name,
                supertype: SuperType.checkSupertype($0.supertype),
                types: $0.types,
                number: $0.number,
                rarity: $0.rarity,
                flavorText: $0.flavorText,
                nationalPokedexNumbers: $0.nationalPokedexNumbers,
                legalities: Legalities(isUnlimited: Legalities.checkLegality(legality: $0.legalities.unlimited), isStandard: Legalities.checkLegality(legality: $0.legalities.standard), isExpanded: Legalities.checkLegality(legality: $0.legalities.expanded)),
                artist: $0.artist,
                cardmarket: CardMarket(url: $0.cardmarket.url,
                                       updatedAt: $0.cardmarket.updatedAt,
                                       prices: CardPrice(
                                        averageSellPrice: $0.cardmarket.prices.averageSellPrice,
                                        lowPrice: $0.cardmarket.prices.lowPrice,
                                        trendPrice: $0.cardmarket.prices.trendPrice,
                                        reverseHoloTrend: $0.cardmarket.prices.reverseHoloTrend,
                                        lowPriceExPlus: $0.cardmarket.prices.lowPriceExPlus,
                                        avg1: $0.cardmarket.prices.avg1,
                                        avg7: $0.cardmarket.prices.avg7,
                                        avg30: $0.cardmarket.prices.avg30)),
                images: CardImages(small: $0.images.small, large: $0.images.large))
        }
    }
}
