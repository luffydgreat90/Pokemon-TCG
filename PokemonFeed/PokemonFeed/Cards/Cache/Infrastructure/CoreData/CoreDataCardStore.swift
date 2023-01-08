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
        return Result {
            try ManagedCard.first(with: url, argumentArray: [#keyPath(ManagedCard.smallUrl),url], in: context)?.smallData
        }
    }
    
    public static func resultSaveRetrieve(data: Data, for url: URL, context: NSManagedObjectContext) -> Result<Void, Error> {
        return Result {
            try ManagedCard.first(with: url, argumentArray: [#keyPath(ManagedCard.smallUrl),url], in: context)
                .map { $0.smallData = data }
                .map(context.save)
        }
    }
    
}
