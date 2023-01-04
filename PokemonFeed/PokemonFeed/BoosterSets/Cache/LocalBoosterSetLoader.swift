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
        
    }
    
    private func cache(_ feed: [BoosterSet], with completion: @escaping (SaveResult) -> Void) {
        
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

private extension Array where Element == LocalBoosterSet {
    func toModels() -> [BoosterSet] {
        return map { BoosterSet(
            id: $0.id,
            name: $0.name,
            series: $0.series,
            printedTotal: $0.printedTotal,
            total: $0.total,
            legalities: BoosterLegalities(isUnlimited: $0.legalities.isUnlimited, isStandard: $0.legalities.isStandard, isExpanded: $0.legalities.isExpanded),
            releaseDate: $0.releaseDate,
            images: BoosterImage(symbol: $0.images.symbol, logo: $0.images.logo))            
        }
    }
}
