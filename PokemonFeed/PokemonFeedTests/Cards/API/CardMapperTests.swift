//
//  CardsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import XCTest
import PokemonFeed

public class CardsMapperTests: XCTestCase {
    func test_map_throws_error() throws {
        
        let json = anyData()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try CardMapper.map(json, from: HTTPURLResponse(statusCode: code)),
                "code is \(code)"
            )
        }
        
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try CardMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try CardMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeCard(id: "id1", name:"Charmander", types: ["Fire"])
        let item2 = makeCard(id: "id2", name:"Alakazam", types: ["Psychic"])
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try CardMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    private func makeCard(id: String,name:String, supertype:String = "Pokémon",rarity:String = "Rare", types:[String]? = nil, number:String = "1", legalities:[String:String] = ["unlimited":"Legal"], artist:String = "John Doe") -> (model: Card, json: [String: Any]) {
        
        let url = anyURL()
        let format = DateFormatter.yearMonthDay
        
        let card = Card(
            id: id,
            name: name,
            supertype: SuperType.checkSupertype(supertype),
            number: number,
            rarity: rarity,
            flavorText: "Test",
            legalities: Legalities(isUnlimited: Legalities.checkLegality(legality: legalities["unlimited"]), isStandard: Legalities.checkLegality(legality: legalities["standard"]), isExpanded: Legalities.checkLegality(legality: legalities["expanded"])),
            artist: artist,
            cardmarket: CardMarket(url: url, updatedAt: format.date(from: "2021/08/27")!, prices: CardPrice(averageSellPrice: 1.0, lowPrice: 1.0, trendPrice: 1.0, reverseHoloTrend: 1.0, lowPriceExPlus: 1.0, avg1: 1.0, avg7: 1.0, avg30: 1.0)),
            images: CardImages(small: url, large: url),
            cardSet: CardSet(id: "123", name: "Base", series: "Base"))
        
        let json = [
            "id": id,
            "name": name,
            "supertype": supertype,
            "number": number,
            "rarity": rarity,
            "flavorText":"Test",
            "legalities": legalities,
            "artist": artist,
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
