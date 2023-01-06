//
//  CardViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public struct CardViewModel {
    public let image:URL
    public let name:String
    public let price:String
    
    public init(image: URL, name: String, price:String) {
        self.image = image
        self.name = name
        self.price = price
    }
}

