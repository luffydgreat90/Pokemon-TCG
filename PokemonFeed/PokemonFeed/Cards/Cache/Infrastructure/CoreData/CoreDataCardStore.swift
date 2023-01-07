//
//  CoreDataCardStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import CoreData

public final class CoreDataCardStore: DataStoreImage {
    
    public static var modelName: String = "CardStore"
    
    public static var model: NSManagedObjectModel = NSManagedObjectModel.with(name: CoreDataCardStore.modelName, in: Bundle(for: CoreDataCardStore.self))!
    
    public static func resultImageRetrieve(dataForURL url: URL, context: NSManagedObjectContext) -> Result<Data?, Error> {
        fatalError("resultImageRetrieve")
    }
    
    public static func resultSaveRetrieve(data: Data, for url: URL, context: NSManagedObjectContext) -> Result<Void, Error> {
        fatalError("resultSaveRetrieve")
    }
    
    
    
   
}
