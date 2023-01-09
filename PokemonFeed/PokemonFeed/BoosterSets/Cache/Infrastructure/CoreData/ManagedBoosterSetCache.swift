//
//  ManagedBoosterSetCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

@objc(ManagedBoosterSetCache)
class ManagedBoosterSetCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var boosterSets: NSOrderedSet
}

extension ManagedBoosterSetCache {
    
    private struct EmptyCache: Error {}
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedBoosterSetCache? {
        try ManagedBoosterSetCache.find(in: context).map {
            CachedBoosterSet(boosterSets: $0.localBoosterSets, timestamp: $0.timestamp)
        }
        
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedBoosterSetCache {
        try find(in: context).map(context.delete)
        return ManagedBoosterSetCache(context: context)
    }

    var localBoosterSets: [LocalBoosterSet] {
        return boosterSets.compactMap { ($0 as? ManagedBoosterSet)?.local }
    }
}
