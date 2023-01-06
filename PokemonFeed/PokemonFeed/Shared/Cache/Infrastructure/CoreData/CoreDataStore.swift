//
//  CoreDataStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import CoreData

public protocol DataStore:AnyObject {}

public final class CoreDataStore<Store:DataStore>{
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
        
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    init(storeURL: URL, modelName:String , store: Store.Type) throws {
        guard let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: store.self)) else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: modelName, model: model, url: storeURL)
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
