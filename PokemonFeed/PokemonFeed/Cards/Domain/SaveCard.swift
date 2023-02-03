//
//  SaveCard.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct SaveCard: Hashable {
    public let quantity: Int
    public let card: Card
    
    public init(quantity: Int, card: Card) {
        self.quantity = quantity
        self.card = card
    }
}
