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
