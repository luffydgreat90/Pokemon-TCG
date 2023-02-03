//
//  LocalDeckLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public final class LocalDeckLoader {
    private let store: DeckStore
    private let currentDate: () -> Date
    
    public init(store: DeckStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalDeckLoader: DeckCache {
    public func save(_ name: String) throws {
        try store.insert(
            LocalDeck(name: name, update: Date(), cards: [])
        )
    }
}
