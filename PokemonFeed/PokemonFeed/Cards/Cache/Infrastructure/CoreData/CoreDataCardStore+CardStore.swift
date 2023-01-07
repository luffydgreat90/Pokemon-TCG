//
//  CoreDataCardStore+CardStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import CoreData

extension CoreDataStore: CardStore where Store: CoreDataCardStore {
    public func deleteCachedCards(completion: @escaping CardStore.DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCardCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ cards: [LocalCard], timestamp: Date, completion: @escaping CardStore.InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCardCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.cards = ManagedCard.cards(from: cards, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping CardStore.RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCardCache.find(in: context).map {
                    CachedCard(cards: $0.localCards, timestamp: $0.timestamp)
                }
            })
        }
    }
    
}
