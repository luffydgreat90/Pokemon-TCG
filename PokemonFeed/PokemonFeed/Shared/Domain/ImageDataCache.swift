//
//  ImageDataCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public protocol ImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
