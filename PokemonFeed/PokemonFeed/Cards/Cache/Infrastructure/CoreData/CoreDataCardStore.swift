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
        if url.absoluteString.contains("small") {
            return Result {
                try ManagedCard.first(with: url, argumentArray: [#keyPath(ManagedCard.smallUrl),url], in: context)?.smallData
            }
        }else{
            return Result {
                try ManagedCard.first(with: url, argumentArray: [#keyPath(ManagedCard.largeUrl),url], in: context)?.largeData
            }
        }
    }
    
    public static func resultSaveRetrieve(data: Data, for url: URL, context: NSManagedObjectContext) -> Result<Void, Error> {
        if url.absoluteString.contains("small") {
            return Result {
                try ManagedCard.first(with: url, argumentArray: [#keyPath(ManagedCard.smallUrl),url], in: context)
                    .map { $0.smallData = data }
                    .map(context.save)
            }
        }else{
            return Result {
                try ManagedCard.first(with: url, argumentArray: [#keyPath(ManagedCard.largeUrl),url], in: context)
                    .map { $0.largeData = data }
                    .map(context.save)
            }
        }
    }
    
}
