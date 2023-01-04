//
//  CoreDataBoosterSetStore+ImageDataLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

extension CoreDataBoosterSetStore: ImageDataStore {
    public func insert(_ data: Data, for url: URL, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedBoosterSet.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            })
        }
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedBoosterSet.first(with: url, in: context)?.data
            })
        }
    }

}
