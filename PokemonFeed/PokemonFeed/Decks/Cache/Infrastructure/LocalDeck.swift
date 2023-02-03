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
    public let saveCards: NSOrderedSet
    
    public init(name: String, update: Date, saveCards: NSOrderedSet) {
        self.name = name
        self.update = update
        self.saveCards = saveCards
    }
}
