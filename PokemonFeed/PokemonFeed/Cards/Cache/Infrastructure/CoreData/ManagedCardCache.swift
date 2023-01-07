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
