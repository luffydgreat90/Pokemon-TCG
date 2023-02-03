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
                managedDeck.name = deck.name
                managedDeck.update = deck.update
                try context.save()
            }
        }
    }
    
    public func update(_ deck: LocalDeck) throws {
        
    }
    
    public func retrieve() throws -> CachedDeck? {
        return nil
    }
        
}
