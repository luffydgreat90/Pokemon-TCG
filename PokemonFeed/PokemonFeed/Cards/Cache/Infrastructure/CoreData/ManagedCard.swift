//
//  ManagedCard.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import CoreData

@objc(ManagedCard)
class ManagedCard: NSManagedObject {
    @NSManaged var artist: String?
    @NSManaged var averageSellPrice: Double
    @NSManaged var flavorText: String?
    @NSManaged var id: String
}


