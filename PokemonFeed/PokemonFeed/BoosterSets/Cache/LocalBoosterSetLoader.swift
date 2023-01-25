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
    public func save(_ boosterSets: [BoosterSet]) throws {
        try store.deleteCachedBoosterSet()
        try store.insert(boosterSets.toLocal(), timestamp: currentDate())
    }
}

extension LocalBoosterSetLoader {
    public func load() throws -> [BoosterSet] {
        if let cache = try store.retrieve(), BoosterSetCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
            return cache.boosterSets.toModels()
        }
        
        return []
    }
}

extension LocalBoosterSetLoader {
    private struct InvalidCache: Error {}

    public func validateCache() throws {
        do {
            if let cache = try store.retrieve(), !BoosterSetCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try store.deleteCachedBoosterSet()
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
