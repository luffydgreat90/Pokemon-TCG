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
    public typealias SaveResult = CardCache.Result
    
    public func save(_ cards: [Card],setId: String, completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedCards(setId: setId) { [weak self] deletionResult in
            guard let self = self else { return }

            switch deletionResult {
            case .success:
                self.cache(cards,setId: setId, with: completion)

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ cards: [Card], setId: String, with completion: @escaping (SaveResult) -> Void) {
        store.insert(cards.toLocal(), setId: setId, timestamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }

            completion(insertionResult)
        }
    }
}

extension LocalCardLoader {
    public typealias LoadResult = Swift.Result<[Card], Error>
    private struct EmptyList: Error {}
    
    public func load(setId: String, completion: @escaping (LoadResult) -> Void) {
        store.retrieve(setId: setId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(.some(cache)) where CardCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.cards.toModels()))

            case .success:
                completion(.failure(EmptyList()))
            }
        }
    }
}

extension LocalCardLoader {
    public typealias ValidationResult = Result<Void, Error>

    public func validateCache(setId: String, completion: @escaping (ValidationResult) -> Void) {
        store.retrieve(setId: setId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                self.store.deleteCachedCards(setId: setId, completion: completion)

            case let .success(.some(cache)) where !CardCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteCachedCards(setId: setId, completion: completion)

            case .success:
                completion(.success(()))
            }
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
                cardmarket: LocalCardMarket(url: $0.cardmarket.url, updatedAt: $0.cardmarket.updatedAt, prices: LocalCardPrice(averageSellPrice: $0.cardmarket.prices.averageSellPrice, lowPrice: $0.cardmarket.prices.lowPrice, trendPrice: $0.cardmarket.prices.trendPrice, reverseHoloTrend: $0.cardmarket.prices.reverseHoloTrend)),
                images: images,
                cardSet: LocalCardSet(id: $0.cardSet.id, name: $0.cardSet.name, series: $0.cardSet.series))
        }
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
                cardmarket: CardMarket(url: $0.cardmarket.url, updatedAt: $0.cardmarket.updatedAt, prices: CardPrice(averageSellPrice: $0.cardmarket.prices.averageSellPrice, lowPrice: $0.cardmarket.prices.lowPrice, trendPrice: $0.cardmarket.prices.trendPrice, reverseHoloTrend: $0.cardmarket.prices.reverseHoloTrend)),
                images: images,
                cardSet: CardSet(id: $0.cardSet.id, name: $0.cardSet.name, series: $0.cardSet.series))
        }
    }
}
