//
//  DeckStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public protocol DeckStore {
    func insert(_ deck: LocalDeck) throws
    func update(_ deck: LocalDeck) throws
    func retrieve() throws -> [LocalDeck]
}
