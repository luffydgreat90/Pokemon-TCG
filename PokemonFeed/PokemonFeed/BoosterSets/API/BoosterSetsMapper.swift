//
//  BoosterSetsMapper.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public enum BoosterSetsMapper {
    
    private struct Root: Decodable {
        let data: [RemoteBoosterSet]
    }
    
    private struct RemoteBoosterSet: Decodable {
        let id: String
        let name: String
        let series: String
        let printedTotal: Int
        let total: Int
        let legalities: RemoteLegalities
        let releaseDate: Date
        let images: RemoteImages
    }
    
    private struct RemoteLegalities: Decodable {
        let unlimited: String?
        let standard: String?
        let expanded: String?
    }
    
    private struct RemoteImages: Decodable {
        let symbol: URL
        let logo: URL
    }
    
    private enum Error: Swift.Error {
        case invalidData
    }
 
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [BoosterSet] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yearMonthDay)
        
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.data.map {
            BoosterSet(id: $0.id,
                       name: $0.name,
                       series: $0.series,
                       printedTotal: $0.printedTotal,
                       total: $0.total,
                       legalities: Legalities(isUnlimited: checkLegality(legality: $0.legalities.unlimited), isStandard: checkLegality(legality: $0.legalities.standard), isExpanded: checkLegality(legality: $0.legalities.expanded)),
                       releaseDate: $0.releaseDate,
                       images: BoosterImage(symbol: $0.images.symbol, logo: $0.images.logo))
        }
    }
    
    public static func checkLegality(legality:String?) -> Bool {
        guard let legality = legality else {
            return false
        }
        
        return legality == "Legal"
    }
}
