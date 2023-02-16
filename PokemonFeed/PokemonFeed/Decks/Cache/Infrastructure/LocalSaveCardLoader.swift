//
//  LocalSaveCardLoader.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 16/02/2023.
//

import Foundation

public final class LocalSaveCardLoader {
    private let store: DeckStore
    private let currentDate: () -> Date
    
    public init(store: DeckStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalSaveCardLoader: SaveCardStore {
    public func insert(_ card: LocalCard) throws {
        
    }
    
    public func remove(_ saveCard: LocalSaveCard) throws {
        
    }
    
    public func retrieve() throws -> [LocalSaveCard] {
        return []
    }
}
