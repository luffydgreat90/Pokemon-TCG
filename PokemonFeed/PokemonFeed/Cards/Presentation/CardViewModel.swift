//
//  CardViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public struct CardViewModel {
    public let name: String
    public let price: String
    
    public init(name: String, price: String) {
        self.name = name
        self.price = price
    }
}

