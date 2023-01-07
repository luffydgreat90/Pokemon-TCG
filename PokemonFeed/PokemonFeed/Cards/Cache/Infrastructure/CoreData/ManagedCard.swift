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
    @NSManaged var setName: String
    @NSManaged var setId: String
    @NSManaged var setSeries: String
}

extension ManagedCard {
    static func cards(from localCard: [LocalCard], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localCard.map { local in
            let managed = ManagedCard(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.number = local.number
            managed.rarity = local.rarity
            managed.flavorText = local.flavorText
            managed.artist = local.artist
            managed.supertype = local.supertype.rawValue
            
            managed.isExpanded = local.legalities.isExpanded
            managed.isStandard = local.legalities.isStandard
            managed.isUnlimited = local.legalities.isUnlimited
           
            managed.largeUrl = local.images?.large
            managed.smallUrl = local.images?.small
            managed.updatedAt = local.cardmarket.updatedAt
            managed.url = local.cardmarket.url
            
            managed.lowPrice = local.cardmarket.prices.lowPrice ?? 0.0
            managed.averageSellPrice = local.cardmarket.prices.averageSellPrice ?? 0.0
            managed.reverseHoloTrend = local.cardmarket.prices.reverseHoloTrend ?? 0.0
            managed.trendPrice = local.cardmarket.prices.trendPrice ?? 0.0
            
            managed.setName = local.cardSet.name
            managed.setId = local.cardSet.id
            managed.setSeries = local.cardSet.series
            return managed
        })
    }
    
    static func first(with url: URL, argumentArray:[Any]?, in context: NSManagedObjectContext) throws -> ManagedCard? {
        let request = NSFetchRequest<ManagedCard>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: argumentArray)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        return try context.fetch(request).first
    }
    
    var local: LocalCard {
        
        var images: LocalCardImages?
        
        if let smallUrl = smallUrl, let largeUrl = largeUrl {
            images = LocalCardImages(small: smallUrl, large: largeUrl)
        }
        
        return LocalCard(
            id: id,
            name: name,
            supertype: SuperType.checkSupertype(supertype),
            number: number,
            rarity: rarity,
            flavorText: flavorText,
            legalities: LocalLegalities(isUnlimited: isUnlimited, isStandard: isStandard, isExpanded: isExpanded),
            artist: artist,
            cardmarket: LocalCardMarket(url: url, updatedAt: updatedAt, prices: LocalCardPrice(averageSellPrice: averageSellPrice, lowPrice: lowPrice, trendPrice: trendPrice, reverseHoloTrend: reverseHoloTrend)),
            images: images,
            cardSet: LocalCardSet(id: setId, name: setName, series: setSeries))
    }
}
