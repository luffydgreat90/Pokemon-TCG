//
//  BoosterSetStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public typealias CachedBoosterSet = (boosterSets: [LocalBoosterSet], timestamp: Date)

public protocol BoosterSetStore {
    func deleteCachedBoosterSet() throws
    func insert(_ boosterSets: [LocalBoosterSet], timestamp: Date) throws
    func retrieve() throws -> CachedBoosterSet?
}
