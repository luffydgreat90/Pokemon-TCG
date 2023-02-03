//
//  Deck.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct Deck: Hashable {
    public let name: String
    public let update: Date
    public let cards: [SaveCard]
    
    public init(name: String, update: Date, cards: [SaveCard]) {
        self.name = name
        self.update = update
        self.cards = cards
    }
}
