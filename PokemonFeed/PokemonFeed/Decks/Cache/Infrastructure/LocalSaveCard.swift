//
//  LocalSaveCard.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct LocalSaveCard {
    public let quantity: Int
    public let card: LocalCard
    
    init(quantity: Int, card: LocalCard) {
        self.quantity = quantity
        self.card = card
    }
}
