//
//  BoosterSetsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import PokemonFeed
import XCTest

public struct BoosterSet {
    let id: String
    let name: String
    let series: String
    let printedTotal: Int
    let total: Int
    let legalities: BoosterLegalities
    let image: URL
    let releaseDate: Date
    let images: BoosterImage
}

public struct BoosterLegalities {
    
}

public struct BoosterImage {
    
}

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
        let image: URL
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
 
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [BoosterSet] {
        return []
    }
}
