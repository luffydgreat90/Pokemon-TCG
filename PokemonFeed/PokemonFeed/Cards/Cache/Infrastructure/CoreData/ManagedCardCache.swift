//
//  ManagedCardCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import CoreData

@objc(ManagedCardCache)
class ManagedCardCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var cards: NSOrderedSet
    @NSManaged var name: String
    @NSManaged var series: String
    @NSManaged var setId: String
}

extension ManagedCardCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedCardCache? {
        let request = NSFetchRequest<ManagedCardCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCardCache {
        try find(in: context).map(context.delete)
        return ManagedCardCache(context: context)
    }
    
    var localCards: [LocalCard] {
        return cards.compactMap { ($0 as? ManagedCard)?.local }
    }
}
