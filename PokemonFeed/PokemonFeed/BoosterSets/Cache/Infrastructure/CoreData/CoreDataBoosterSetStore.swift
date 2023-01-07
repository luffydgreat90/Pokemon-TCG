//
//  CoreDataBoosterSetStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

public final class CoreDataBoosterSetStore: DataStore {
    public static var model: NSManagedObjectModel =  NSManagedObjectModel.with(name: CoreDataBoosterSetStore.modelName, in: Bundle(for: CoreDataBoosterSetStore.self))!
    
    public static var modelName: String =  "BoosterSetStore"
}
