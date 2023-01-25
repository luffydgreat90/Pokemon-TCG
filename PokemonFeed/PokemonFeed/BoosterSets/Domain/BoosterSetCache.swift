//
//  BoosterSetCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public protocol BoosterSetCache {
    func save(_ boosterSets: [BoosterSet]) throws
}
