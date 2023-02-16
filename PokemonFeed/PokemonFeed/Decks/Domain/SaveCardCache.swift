//
//  SaveCardCache.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 16/02/2023.
//

import Foundation

public protocol SaveCardCache {
    func save(_ name: String) throws
}
