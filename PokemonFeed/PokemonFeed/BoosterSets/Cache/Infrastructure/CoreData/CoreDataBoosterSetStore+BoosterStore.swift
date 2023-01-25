//
//  CoreDataBoosterSetStore+BoosterSetStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

extension CoreDataStore: BoosterSetStore where Store: CoreDataBoosterSetStore {
    public func retrieve() throws -> CachedBoosterSet? {
        try performSync { context in
            Result {
                try ManagedBoosterSetCache.find(in: context).map {
                    CachedBoosterSet(
                        boosterSets: $0.localBoosterSets,
                        timestamp: $0.timestamp)
                }
            }
        }
    }
    
    public func deleteCachedBoosterSet() throws {
        try performSync { context in
            Result {
                try ManagedBoosterSetCache
                .deleteCache(in: context)
                
            }
        }
    }
    
    public func insert(_ boosterSets: [LocalBoosterSet], timestamp: Date) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedBoosterSetCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.boosterSets = ManagedBoosterSet.boosterSets(from: boosterSets, in: context)
                try context.save()
            }
        }
    }
}
