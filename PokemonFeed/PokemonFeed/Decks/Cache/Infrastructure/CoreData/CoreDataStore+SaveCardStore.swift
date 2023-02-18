//
//  CoreDataStore+SaveCardStore.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 17/02/2023.
//

import Foundation

extension CoreDataStore: SaveCardStore {
    public func insert(_ card: LocalCard) throws {
        
    }
    
    public func remove(_ saveCard: LocalSaveCard) throws {
        
    }
    
    public func retrieve() throws -> [LocalSaveCard] {
        return []
    }
}
