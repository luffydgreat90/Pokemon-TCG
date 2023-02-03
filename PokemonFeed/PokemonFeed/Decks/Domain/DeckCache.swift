//
//  DeckCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public protocol DeckCache {
    func save(_ name: String) throws
}
