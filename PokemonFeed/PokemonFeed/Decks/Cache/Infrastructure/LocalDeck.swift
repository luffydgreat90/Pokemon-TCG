//
//  LocalDeck.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct LocalDeck {
    public let name: String
    public let update: Date
    public let cards: [LocalSaveCard]
    
    public init(name: String, update: Date, cards: [LocalSaveCard]) {
        self.name = name
        self.update = update
        self.cards = cards
    }
}
