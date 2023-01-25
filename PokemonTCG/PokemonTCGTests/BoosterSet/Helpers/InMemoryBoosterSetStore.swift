//
//  InMemoryFeedStore.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import Foundation
import PokemonFeed

class InMemoryBoosterSetStore {
    private(set) var boosterSetCache: CachedBoosterSet?
    private var imageDataCache: [URL: Data] = [:]
    
    private init(boosterSetCache: CachedBoosterSet? = nil) {
        self.boosterSetCache = boosterSetCache
    }
}

extension InMemoryBoosterSetStore: BoosterSetStore {
    func deleteCachedBoosterSet() throws {
        boosterSetCache = nil
    }
    
    func insert(_ boosterSets: [LocalBoosterSet], timestamp: Date) throws {
        boosterSetCache = CachedBoosterSet(boosterSets:boosterSets, timestamp: Date())
    }

    func retrieve() throws -> CachedBoosterSet? {
        boosterSetCache
    }
}

extension InMemoryBoosterSetStore: ImageDataStore {
    func insert(_ data: Data, for url: URL) throws {
        imageDataCache[url] = data
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        imageDataCache[url]
    }
}

extension InMemoryBoosterSetStore {
    static var empty: InMemoryBoosterSetStore {
        InMemoryBoosterSetStore()
    }
    
    static var withExpiredFeedCache: InMemoryBoosterSetStore {
        InMemoryBoosterSetStore(boosterSetCache: CachedBoosterSet(boosterSets: [], timestamp: Date.distantPast))
    }
}
