//
//  CardCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import Foundation

public protocol CardCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ cards: [Card], setId:String, completion: @escaping (Result) -> Void)
}
