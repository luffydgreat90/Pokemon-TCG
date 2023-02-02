//
//  LocalCardLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import Foundation

public final class LocalCardLoader {
    private let store: CardStore
    private let currentDate: () -> Date
    
    public init(store: CardStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalCardLoader: CardCache {
    
    public func save(_ cards: [Card], setId: String) throws {
        try store.deleteCachedCards(setId: setId)
        try store.insert(cards.toLocal(), setId: setId, timestamp: currentDate())
    }
}

extension LocalCardLoader {
    public typealias LoadResult = Swift.Result<[Card], Error>
    public struct EmptyList: Error {
        public init() {}
    }
    
    public func load(setID: String) throws -> [Card] {
        if let cache = try store.retrieve(setID: setID), CardCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
            return cache.cards.toModels()
        }else{
            throw EmptyList()
        }
    }
}

extension LocalCardLoader {
    private struct InvalidCache: Error {}

    public func validateCache(setId: String) throws {
        do {
            if let cache = try store.retrieve(setID: setId), !CardCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try store.deleteCachedCards(setId: setId)
        }
    }
}

public extension Array where Element == Card {
    func toLocal() -> [LocalCard] {
        return map {
            let images: LocalCardImages? = $0.images != nil ? LocalCardImages(small: $0.images!.small, large: $0.images!.large) : nil
            
            return LocalCard(
                id: $0.id,
                name: $0.name,
                supertype: $0.supertype,
                number: $0.number,
                rarity: $0.rarity,
                flavorText: $0.flavorText,
                legalities: LocalLegalities(isUnlimited: $0.legalities.isUnlimited, isStandard: $0.legalities.isStandard, isExpanded: $0.legalities.isExpanded),
                artist: $0.artist,
                cardmarket: getLocalCardMarket(cardmarket: $0.cardmarket),
                images: images,
                cardSet: LocalCardSet(id: $0.cardSet.id, name: $0.cardSet.name, series: $0.cardSet.series))
        }
    }
    
    private func getLocalCardMarket(cardmarket: CardMarket?) -> LocalCardMarket? {
        guard let cardmarket = cardmarket else {
            return nil
        }
        
        return LocalCardMarket(
            url: cardmarket.url,
            updatedAt: cardmarket.updatedAt,
            prices: LocalCardPrice(
                averageSellPrice: cardmarket.prices.averageSellPrice,
                lowPrice: cardmarket.prices.lowPrice,
                trendPrice: cardmarket.prices.trendPrice,
                reverseHoloTrend: cardmarket.prices.reverseHoloTrend)
        )
    }
}

public extension Array where Element == LocalCard {
    func toModels() -> [Card] {
        return map {
            let images: CardImages? = $0.images != nil ? CardImages(small: $0.images!.small, large: $0.images!.large) : nil
            
            return Card(
                id: $0.id,
                name: $0.name,
                supertype: $0.supertype,
                number: $0.number,
                rarity: $0.rarity,
                flavorText: $0.flavorText,
                legalities: Legalities(isUnlimited: $0.legalities.isUnlimited, isStandard: $0.legalities.isStandard, isExpanded: $0.legalities.isExpanded),
                artist: $0.artist,
                cardmarket: getCardMarket(cardmarket: $0.cardmarket),
                images: images,
                cardSet: CardSet(id: $0.cardSet.id, name: $0.cardSet.name, series: $0.cardSet.series))
        }
    }
    
    private func getCardMarket(cardmarket: LocalCardMarket?) -> CardMarket? {
        guard let cardmarket = cardmarket else {
            return nil
        }
        
        return CardMarket(
            url: cardmarket.url,
            updatedAt: cardmarket.updatedAt,
            prices: CardPrice(
                averageSellPrice: cardmarket.prices.averageSellPrice,
                lowPrice: cardmarket.prices.lowPrice,
                trendPrice: cardmarket.prices.trendPrice,
                reverseHoloTrend: cardmarket.prices.reverseHoloTrend)
        )
    }
}
