//
//  ManagedBoosterSet.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import CoreData

@objc(ManagedBoosterSet)
class ManagedBoosterSet: NSManagedObject {
    @NSManaged var data: Data
    @NSManaged var id: String
    @NSManaged var isExpanded: Bool
    @NSManaged var isStandard: Bool
    @NSManaged var isUnlimited: Bool
    @NSManaged var logo: URL
    @NSManaged var name: String
    @NSManaged var printedTotal: Int16
    @NSManaged var releaseDate: Date
    @NSManaged var series: String
    @NSManaged var symbol: URL
    @NSManaged var total: Int16
    @NSManaged var cache: ManagedBoosterSetCache
}

extension ManagedBoosterSet {
    
    static func boosterSets(from localBoosterSet: [LocalBoosterSet], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localBoosterSet.map { local in
            let managed = ManagedBoosterSet(context: context)
            managed.id = local.id
            managed.isExpanded = local.legalities.isExpanded
            managed.isStandard = local.legalities.isStandard
            managed.isUnlimited = local.legalities.isUnlimited
            managed.logo = local.images.logo
            managed.name = local.name
            managed.printedTotal = Int16(local.printedTotal)
            managed.releaseDate = local.releaseDate
            managed.series = local.series
            managed.symbol = local.images.symbol
            managed.total = Int16(local.total)
            return managed
        })
    }
    
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedBoosterSet? {
        let request = NSFetchRequest<ManagedBoosterSet>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedBoosterSet.logo), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    var local: LocalBoosterSet {
        return LocalBoosterSet(
            id: id,
            name: name,
            series: series,
            printedTotal: Int(printedTotal),
            total: Int(total),
            legalities: LocalLegalities(isUnlimited: isUnlimited, isStandard: isStandard, isExpanded: isExpanded),
            releaseDate: releaseDate,
            images: LocalImages(symbol: symbol, logo: logo))
    }
    
}
