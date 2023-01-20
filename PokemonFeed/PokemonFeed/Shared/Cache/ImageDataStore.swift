//
//  ImageDataStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public protocol ImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
