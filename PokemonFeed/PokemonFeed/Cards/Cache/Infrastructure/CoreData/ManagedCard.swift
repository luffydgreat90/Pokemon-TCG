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
    @NSManaged var isExpanded: Bool
    @NSManaged var isStandard: Bool
    @NSManaged var isUnlimited: Bool
    @NSManaged var largeUrl: URL?
    @NSManaged var smallUrl: URL?
    @NSManaged var lowPrice: Double
    @NSManaged var name: String
    @NSManaged var number: String
    @NSManaged var rarity: String
    @NSManaged var reverseHoloTrend: Double
    @NSManaged var smallData: Data?
    @NSManaged var largeData: Data?
    @NSManaged var supertype: String
    @NSManaged var trendPrice: Double
    @NSManaged var updatedAt: Date
    @NSManaged var url: URL
}



