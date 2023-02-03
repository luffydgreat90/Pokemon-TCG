//
//  ManageDeck.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/30/23.
//

import CoreData

@objc(ManagedDeck)
class ManagedDeck: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var update: Date
    @NSManaged var saveCards: NSOrderedSet
}

extension ManagedDeck {
    static func newDeckInstance(name: String, update: Date, in context: NSManagedObjectContext) throws -> ManagedDeck {
        let managed = ManagedDeck(context: context)
        managed.name = name
        managed.update = update
        managed.saveCards = NSOrderedSet()
        return managed
    }
    
}
