//
//  CoreDataBoosterSetStore+BoosterSetStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

extension CoreDataStore: BoosterSetStore where Store: CoreDataBoosterSetStore {
    public func retrieve(completion: @escaping BoosterSetStore.RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedBoosterSetCache.find(in: context).map {
                    CachedBoosterSet(boosterSets: $0.localBoosterSets, timestamp: $0.timestamp)
                }
            })
        }
    }
    
    public func deleteCachedBoosterSet(completion: @escaping BoosterSetStore.DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedBoosterSetCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ boosterSets: [LocalBoosterSet], timestamp: Date, completion: @escaping BoosterSetStore.InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedBoosterSetCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.boosterSets = ManagedBoosterSet.boosterSets(from: boosterSets, in: context)
                try context.save()
            })
        }
    }
}
