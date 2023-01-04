//
//  ManagedBoosterSetCache.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

@objc(ManagedBoosterSetCache)
class ManagedBoosterSetCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var boosterSets: NSOrderedSet
}

extension ManagedBoosterSetCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedBoosterSetCache? {
        let request = NSFetchRequest<ManagedBoosterSetCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedBoosterSetCache {
        try find(in: context).map(context.delete)
        return ManagedBoosterSetCache(context: context)
    }

    var localBoosterSets: [LocalBoosterSet] {
        return boosterSets.compactMap { ($0 as? ManagedBoosterSet)?.local }
    }
}
