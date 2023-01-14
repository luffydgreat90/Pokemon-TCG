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
        let number: String
        let rarity: String?
        let flavorText: String?
        let legalities: RemoteLegalities?
        let artist: String?
        let cardmarket: RemoteCardMarket
        let images: RemoteImages?
        let set: RemoteSet
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
    }
    
    private struct RemoteSet: Decodable {
        let id: String
        let name: String
        let series: String
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
            
            var cardImages:CardImages? = nil
            
            if let images = $0.images {
                cardImages = CardImages(small: images.small, large: images.large)
            }
            
            let legalities: Legalities = getLegalities(remoteLegalities: $0.legalities)
            
            return Card(
                id: $0.id,
                name: $0.name,
                supertype: SuperType.checkSupertype($0.supertype),
                number: $0.number,
                rarity: $0.rarity,
                flavorText: $0.flavorText,
                legalities: legalities,
                artist: $0.artist,
                cardmarket: CardMarket(url: $0.cardmarket.url,
                                       updatedAt: $0.cardmarket.updatedAt,
                                       prices: CardPrice(
                                        averageSellPrice: $0.cardmarket.prices.averageSellPrice,
                                        lowPrice: $0.cardmarket.prices.lowPrice,
                                        trendPrice: $0.cardmarket.prices.trendPrice,
                                        reverseHoloTrend: $0.cardmarket.prices.reverseHoloTrend)),
                images: cardImages,
                cardSet: CardSet(
                    id: $0.set.id,
                    name: $0.set.name,
                    series: $0.set.series))
        }
    }
    
    private static func getLegalities(remoteLegalities: RemoteLegalities?) -> Legalities {
        guard let remoteLegalities = remoteLegalities else{
            return Legalities(isUnlimited: false, isStandard: false, isExpanded: false)
        }
     
        return Legalities(isUnlimited: Legalities.checkLegality(legality: remoteLegalities.unlimited), isStandard: Legalities.checkLegality(legality: remoteLegalities.standard), isExpanded: Legalities.checkLegality(legality: remoteLegalities.expanded))
    }
}
