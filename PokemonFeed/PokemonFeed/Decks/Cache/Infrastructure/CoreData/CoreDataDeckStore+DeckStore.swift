//
//  CoreDataDeckStore+DeckStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

extension CoreDataStore: DeckStore {
    public func insert(_ deck: LocalDeck) throws {
        try performSync { context in
            Result {
                let managedDeck = ManagedDeck(context: context)
                managedDeck.id = deck.id
                managedDeck.name = deck.name
                managedDeck.update = deck.update
                try context.save()
            }
        }
    }
    
    public func update(_ deck: LocalDeck) throws {
        
    }
    
    public func retrieve() throws -> [LocalDeck] {
        try performSync { context in
            Result {
                try ManagedDeck.find(in: context).map { deck in
                    LocalDeck(id: deck.id,
                              name: deck.name,
                              update: deck.update,
                              cards: deck.saveCards.compactMap({
                            ($0 as? ManagedSaveCard)?.local
                    }))
                }
            }
        }
    }
        
}
