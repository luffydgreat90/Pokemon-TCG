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
    static func find(in context: NSManagedObjectContext) throws -> [ManagedDeck] {
        let request = NSFetchRequest<ManagedDeck>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
    
    static func newDeckInstance(name: String, update: Date, in context: NSManagedObjectContext) throws -> ManagedDeck {
        let managed = ManagedDeck(context: context)
        managed.name = name
        managed.update = update
        managed.saveCards = NSOrderedSet()
        return managed
    }
    
    var localCards: [LocalSaveCard] {
        return saveCards.compactMap { ($0 as? ManagedSaveCard)?.local }
    }
    
}
