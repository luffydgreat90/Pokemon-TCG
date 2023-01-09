//
//  LocalBoosterSetLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public final class LocalBoosterSetLoader {
    private let store: BoosterSetStore
    private let currentDate: () -> Date
    
    public init(store: BoosterSetStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalBoosterSetLoader: BoosterSetCache {
    public typealias SaveResult = BoosterSetCache.Result
    
    public func save(_ feed: [BoosterSet], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedBoosterSet { [weak self] deletionResult in
            guard let self = self else { return }

            switch deletionResult {
            case .success:
                self.cache(feed, with: completion)

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ boosterSets: [BoosterSet], with completion: @escaping (SaveResult) -> Void) {
        store.insert(boosterSets.toLocal(), timestamp: currentDate()) { [weak self] insertionResult in
            guard self != nil else { return }

            completion(insertionResult)
        }
    }
}

extension LocalBoosterSetLoader {
    public typealias LoadResult = Swift.Result<[BoosterSet], Error>
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(.some(cache)) where BoosterSetCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                completion(.success(cache.boosterSets.toModels()))

            case .success:
                completion(.success([]))
            }
        }
    }
}

extension LocalBoosterSetLoader {
    public typealias ValidationResult = Result<Void, Error>

    public func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                self.store.deleteCachedBoosterSet(completion: completion)

            case let .success(.some(cache)) where !BoosterSetCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteCachedBoosterSet(completion: completion)

            case .success:
                completion(.success(()))
            }
        }
    }
}

public extension Array where Element == BoosterSet {
    func toLocal() -> [LocalBoosterSet] {
        return map {
            LocalBoosterSet(
                id: $0.id,
                name: $0.name,
                series: $0.series,
                printedTotal: $0.printedTotal,
                total: $0.total,
                legalities: LocalLegalities(isUnlimited: $0.legalities.isUnlimited, isStandard: $0.legalities.isStandard, isExpanded: $0.legalities.isExpanded),
                releaseDate: $0.releaseDate,
                images: LocalImages(symbol: $0.images.symbol, logo: $0.images.logo))
        }
    }
}

public extension Array where Element == LocalBoosterSet {
    func toModels() -> [BoosterSet] {
        return map { BoosterSet(
            id: $0.id,
            name: $0.name,
            series: $0.series,
            printedTotal: $0.printedTotal,
            total: $0.total,
            legalities: Legalities(isUnlimited: $0.legalities.isUnlimited, isStandard: $0.legalities.isStandard, isExpanded: $0.legalities.isExpanded),
            releaseDate: $0.releaseDate,
            images: BoosterImage(symbol: $0.images.symbol, logo: $0.images.logo))            
        }
    }
}
