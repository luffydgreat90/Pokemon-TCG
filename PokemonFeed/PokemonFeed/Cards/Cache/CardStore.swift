//
//  CardStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import Foundation

public typealias CachedCard = (cards: [LocalCard], setID: String, timestamp: Date)

public protocol CardStore {
    func deleteCachedCards(setId: String) throws
    func insert(_ cards: [LocalCard], setId: String, timestamp: Date) throws
    func retrieve(setID: String) throws -> CachedCard?
}
