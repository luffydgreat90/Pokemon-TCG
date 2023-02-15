//
//  SaveCardViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 15/02/2023.
//

import Foundation

public struct SaveCardViewModel {
    public let name: String
    public let quantity: Int
    public let type: String
    public let price: String
    
    public init(name: String, quantity: Int, type: String, price: String) {
        self.name = name
        self.quantity = quantity
        self.type = type
        self.price = price
    }
}
