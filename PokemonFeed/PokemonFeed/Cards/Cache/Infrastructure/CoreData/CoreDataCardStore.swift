//
//  CoreDataCardStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import CoreData

public final class CoreDataCardStore {
    private static let modelName = "CardStore"
    
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataCardStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    init(container: NSPersistentContainer, context: NSManagedObjectContext) {
        self.container = container
        self.context = context
    }
}
