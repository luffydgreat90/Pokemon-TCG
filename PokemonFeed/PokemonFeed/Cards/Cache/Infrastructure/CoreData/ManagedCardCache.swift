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
    @NSManaged var setId: String
}

extension ManagedCardCache {
    static func find(setId: String, in context: NSManagedObjectContext) throws -> ManagedCardCache? {
        let request = NSFetchRequest<ManagedCardCache>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedCardCache.setId), setId])
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(setId: String, in context: NSManagedObjectContext) throws -> ManagedCardCache {
        try find(setId: setId, in: context).map(context.delete)
        return ManagedCardCache(context: context)
    }
    
    var localCards: [LocalCard] {
        return cards.compactMap { ($0 as? ManagedCard)?.local }
    }
}
