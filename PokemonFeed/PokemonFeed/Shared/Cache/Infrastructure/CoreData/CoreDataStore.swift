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

public protocol DataStoreImage: DataStore {
    static func resultImageRetrieve(dataForURL url: URL, context: NSManagedObjectContext) -> Result<Data?, Error>
    static func resultSaveRetrieve(data: Data, for url: URL, context: NSManagedObjectContext) -> Result<Void, Error>
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

extension CoreDataStore: ImageDataStore where Store: DataStoreImage {
    public func insert(_ data: Data, for url: URL, completion: @escaping (ImageDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Store.resultSaveRetrieve(data: data, for: url, context: context))
        }
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (ImageDataStore.RetrievalResult) -> Void) {
        perform { context in
            completion(Store.resultImageRetrieve(dataForURL: url, context: context))
        }
    }
}
