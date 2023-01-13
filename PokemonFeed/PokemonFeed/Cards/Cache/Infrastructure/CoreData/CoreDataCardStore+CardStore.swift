//
//  CoreDataCardStore+CardStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import CoreData

extension CoreDataStore: CardStore where Store: CoreDataCardStore {
    public func deleteCachedCards(setId: String, completion: @escaping CardStore.DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCardCache.find(setId: setId,in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ cards: [LocalCard], setId: String,timestamp: Date, completion: @escaping CardStore.InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCardCache.newUniqueInstance(setId: setId,in: context)
                managedCache.timestamp = timestamp
                managedCache.setId = setId
                managedCache.cards = ManagedCard.cards(from: cards, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(setID: String, completion: @escaping CardStore.RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCardCache.find(setId: setID, in: context).map {
                    CachedCard(cards: $0.localCards, setID: setID, timestamp: $0.timestamp)
                }
            })
        }
    }
    
}
