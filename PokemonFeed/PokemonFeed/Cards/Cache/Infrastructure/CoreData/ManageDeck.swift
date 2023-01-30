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
