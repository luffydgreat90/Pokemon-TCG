//
//  CardCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import Foundation

public protocol CardCache {
    func save(_ cards: [Card], setId:String) throws
}
