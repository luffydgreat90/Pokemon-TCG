//
//  CardsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import XCTest
import PokemonFeed


public struct Card: Equatable {
    public let id: String
    public let name: String
    public let supertype: SuperType
    public let types: [String]?
    public let number: String
    public let rarity: String
    public let flavorText: String?
    public let nationalPokedexNumbers: [Int]
    public let legalities: Legalities
    public let artist: String
    public let cardmarket: CardMarket
    public let images: CardImages
}

public struct CardMarket: Equatable {
    public let url: URL
    public let updatedAt: Date
    public let prices: CardPrice
}

public struct CardImages: Equatable {
    public let small: URL
    public let large: URL
}

public struct CardPrice: Equatable {
    public let averageSellPrice: Double
    public let lowPrice: Double
    public let trendPrice: Double
    public let reverseHoloTrend: Double
    public let lowPriceExPlus: Double
    public let avg1: Double
    public let avg7: Double
    public let avg30: Double
}

public enum SuperType {
    case trainer, energy, pokemon, unknown
    
    public static func checkSupertype(_ superType: String) -> SuperType {
        switch superType {
            case "Trainer": return .trainer
            case "Pokémon": return .pokemon
            case "Energy": return .energy
            default: return .unknown
        }
    }
}

public enum CardsMapper {
    private struct Root: Decodable {
        let data: [RemoteCard]
    }
    
    private struct RemoteCard: Decodable {
        let id: String
        let name: String
        let supertype: String
        let types: [String]?
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
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Card] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.yearMonthDay)
        
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.data.map {
            Card(
                id: $0.id,
                name: $0.name,
                supertype: SuperType.checkSupertype($0.supertype),
                types: $0.types,
                number: $0.number,
                rarity: $0.rarity,
                flavorText: $0.flavorText,
                nationalPokedexNumbers: $0.nationalPokedexNumbers,
                legalities: Legalities(isUnlimited: Legalities.checkLegality(legality: $0.legalities.unlimited), isStandard: Legalities.checkLegality(legality: $0.legalities.standard), isExpanded: Legalities.checkLegality(legality: $0.legalities.expanded)),
                artist: $0.artist,
                cardmarket: CardMarket(url: $0.cardmarket.url,
                                       updatedAt: $0.cardmarket.updatedAt,
                                       prices: CardPrice(
                                        averageSellPrice: $0.cardmarket.prices.averageSellPrice,
                                        lowPrice: $0.cardmarket.prices.lowPrice,
                                        trendPrice: $0.cardmarket.prices.trendPrice,
                                        reverseHoloTrend: $0.cardmarket.prices.reverseHoloTrend,
                                        lowPriceExPlus: $0.cardmarket.prices.lowPriceExPlus,
                                        avg1: $0.cardmarket.prices.avg1,
                                        avg7: $0.cardmarket.prices.avg7,
                                        avg30: $0.cardmarket.prices.avg30)),
                images: CardImages(small: $0.images.small, large: $0.images.large))
        }
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
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try CardsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try CardsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeCard(id: "id1", name:"Charmander", types: ["Fire"])
        let item2 = makeCard(id: "id2", name:"Alakazam", types: ["Psychic"])
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try CardsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    private func makeCard(id: String,name:String, supertype:String = "Pokémon",rarity:String = "Rare", types:[String]? = nil, legalities:[String:String] = ["unlimited":"Legal"]) -> (model: Card, json: [String: Any]) {
        
        let url = anyURL()
        let format = DateFormatter.yearMonthDay
        
        let card = Card(
            id: id,
            name: name,
            supertype: SuperType.checkSupertype(supertype),
            types: types,
            number: "1",
            rarity: rarity,
            flavorText: "Test",
            nationalPokedexNumbers: [1],
            legalities: Legalities(isUnlimited: Legalities.checkLegality(legality: legalities["unlimited"]), isStandard: Legalities.checkLegality(legality: legalities["standard"]), isExpanded: Legalities.checkLegality(legality: legalities["expanded"])),
            artist: "Test",
            cardmarket: CardMarket(url: url, updatedAt: format.date(from: "2021/08/27")!, prices: CardPrice(averageSellPrice: 1.0, lowPrice: 1.0, trendPrice: 1.0, reverseHoloTrend: 1.0, lowPriceExPlus: 1.0, avg1: 1.0, avg7: 1.0, avg30: 1.0)),
            images: CardImages(small: url, large: url))
        
        let json = [
            "id": id,
            "name": name,
            "supertype": supertype,
            "types": types!,
            "number": "1",
            "rarity": rarity,
            "flavorText":"Test",
            "nationalPokedexNumbers": [1],
            "legalities": legalities,
            "artist": "Test",
            "cardmarket": [
                "url":url.absoluteString,
                "updatedAt":"2021/08/27",
                "prices":[
                    "averageSellPrice": 1.0,
                    "lowPrice": 1.0,
                    "trendPrice": 1.0,
                    "reverseHoloTrend": 1.0,
                    "lowPriceExPlus": 1.0,
                    "avg1": 1.0,
                    "avg7": 1.0,
                    "avg30": 1.0
                ]
            ],
            "images": [
                "small": url.absoluteString,
                "large": url.absoluteString
            ]
        ].compactMapValues { $0 }
        
        return (card, json)
    }
}
