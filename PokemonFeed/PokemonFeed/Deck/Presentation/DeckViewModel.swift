//
//  DeckViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct DeckViewModel {
    public let name: String
    public let update: String
    
    public init(name: String, update: String) {
        self.name = name
        self.update = update
    }
}
