//
//  LocalDeck.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct LocalDeck {
    public let id: String
    public let name: String
    public let update: Date
    public let cards: [LocalSaveCard]
    
    public init(id: String, name: String, update: Date, cards: [LocalSaveCard]) {
        self.id = id
        self.name = name
        self.update = update
        self.cards = cards
    }
}
