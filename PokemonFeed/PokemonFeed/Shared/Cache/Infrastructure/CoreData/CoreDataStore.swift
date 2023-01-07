//
//  CoreDataStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import CoreData

public protocol DataStore {
    static var modelName: String { get }
    static var model: NSManagedObjectModel { get }
}

public final class CoreDataStore<Store:DataStore>{
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
        
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL, store:Store.Type) throws {
        do {
            container = try NSPersistentContainer.load(name: store.modelName, model: store.model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        context.perform { [context] in action(context) }
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

extension CoreDataStore: BoosterSetStore {
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedBoosterSetCache.find(in: context).map {
                    CachedBoosterSet(boosterSets: $0.localBoosterSets, timestamp: $0.timestamp)
                }
            })
        }
    }
    
    public func deleteCachedBoosterSet(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedBoosterSetCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ boosterSets: [LocalBoosterSet], timestamp: Date, completion: @escaping InsertionCompletion) {
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
 
extension CoreDataStore: ImageDataStore {
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
