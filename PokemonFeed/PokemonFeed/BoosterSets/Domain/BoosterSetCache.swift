//
//  BoosterSetCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public protocol BoosterSetCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [BoosterSet], completion: @escaping (Result) -> Void)
}
