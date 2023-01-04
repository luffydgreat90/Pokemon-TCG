//
//  CardsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import PokemonFeed
import XCTest

public enum CardsMapper{
    private struct Root: Decodable {
        let data: [RemoteCard]
    }
    
    private struct RemoteCard: Decodable {
        let id: String
        let name: String
        let supertype: String
        let types: [String]
        let evolvesFrom: String
        let number: String
        let rarity: String
        let flavorText: String?
        let nationalPokedexNumbers: [Int]
        let legalities: RemoteLegalities
        let artist: String
        let cardmarket: RemoteCardMarket
        let images: RemoteImages
    }
    
    private struct RemoteImages: Decodable {
        let small: URL
        let large: URL
    }
    
    private struct RemoteLegalities: Decodable {
        let unlimited: String?
        let standard: String?
        let expanded: String?
    }
    
    private struct RemoteCardMarket: Decodable {
        let url: URL
        let updatedAt: Date
        let prices: RemotePrice
    }
    
    private struct RemotePrice: Decodable {
        let averageSellPrice: Double
        let lowPrice: Double
        let trendPrice: Double
        let reverseHoloTrend: Double
        let lowPriceExPlus: Double
        let avg1: Double
        let avg7: Double
        let avg30: Double
    }
}


public enum CardsMapperTests {
    
}
