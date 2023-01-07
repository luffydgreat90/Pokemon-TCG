//
//  CoreDataBoosterSetStore.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

public final class CoreDataBoosterSetStore: DataStoreImage {
    public static var model: NSManagedObjectModel =  NSManagedObjectModel.with(name: CoreDataBoosterSetStore.modelName, in: Bundle(for: CoreDataBoosterSetStore.self))!
    
    public static var modelName: String =  "BoosterSetStore"
    
    public static func resultImageRetrieve(dataForURL url: URL, context: NSManagedObjectContext) -> Result<Data?, Error> {
        return Result {
            try ManagedBoosterSet.first(with: url, in: context)?.data
        }
    }
    
    public static func resultSaveRetrieve(data: Data, for url: URL, context: NSManagedObjectContext) -> Result<Void, Error> {
        Result {
            try ManagedBoosterSet.first(with: url, in: context)
                .map { $0.data = data }
                .map(context.save)
        }
    }
}
