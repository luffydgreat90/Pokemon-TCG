//
//  ManageDeck.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/30/23.
//

import CoreData

@objc(ManagedDeck)
class ManagedDeck: NSManagedObject {
    @NSManaged var id: String
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
    
    var localCards: [LocalSaveCard] {
        return saveCards.compactMap { ($0 as? ManagedSaveCard)?.local }
    }
}
