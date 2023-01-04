//
//  CardsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import PokemonFeed
import XCTest

public enum CardsMapper {
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
    
    private enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [BoosterSet] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yearMonthDay)
        
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return []
    }
}


public class CardsMapperTests: XCTestCase {
    func test_map_throws_error() throws {
        
        let json = anyData()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try CardsMapper.map(json, from: HTTPURLResponse(statusCode: code)),
                "code is \(code)"
            )
        }
        
    }
}
