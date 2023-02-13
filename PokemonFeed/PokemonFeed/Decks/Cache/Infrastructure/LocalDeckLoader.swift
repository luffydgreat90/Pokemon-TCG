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

extension LocalDeckLoader {
    public func load() throws -> [Deck] {
        if let cache = try? store.retrieve() {
            return cache.toModels()
        }
        
        return []
    }
}

public extension Array where Element == LocalDeck {
    func toModels() -> [Deck] {
        return map {
            Deck(name: $0.name,
                 update: $0.update,
                 cards: $0.cards.toModels())
        }
    }
}

public extension Array where Element == LocalSaveCard {
    func toModels() -> [SaveCard] {
        return map {
            SaveCard(quantity: $0.quantity,
                     card: $0.card.toCard())
        }
    }
}
