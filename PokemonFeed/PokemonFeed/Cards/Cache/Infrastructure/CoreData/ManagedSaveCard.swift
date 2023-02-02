//
//  ManagedSaveCard.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/27/23.
//

import CoreData

@objc(ManagedSaveCard)
class ManagedSaveCard: NSManagedObject {
    @NSManaged var quantity: Int16
    @NSManaged var card: ManagedCard
}
