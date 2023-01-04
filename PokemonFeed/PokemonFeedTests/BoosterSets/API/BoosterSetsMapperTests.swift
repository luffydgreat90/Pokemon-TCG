//
//  BoosterSetsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import PokemonFeed
import XCTest

final class BoosterSetsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = anyData()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try BoosterSetsMapper.map(json, from: HTTPURLResponse(statusCode: code)),
                "code is \(code)"
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try BoosterSetsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try BoosterSetsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeBoosterSet(id: "base1")
        let item2 = makeBoosterSet(id: "base2", legalities: ["unlimited":"Legal", "standard":"Legal" , "expanded":"Legal"])
        
        let json = makeItemsJSON([item1.json, item2.json])
        let result = try BoosterSetsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    private func makeBoosterSet(id: String, legalities:[String:String] = ["unlimited":"Legal"]) -> (model: BoosterSet, json: [String: Any]) {
        
        let url = anyURL()
        let format = DateFormatter.yearMonthDay
        
        let boosterSet:BoosterSet = BoosterSet(
            id: id,
            name: "Booster \(id)",
            series: "Series \(id)",
            printedTotal: 10,
            total: 10,
            legalities: Legalities(
                isUnlimited: BoosterSetsMapper.checkLegality(legality: legalities["unlimited"]),
                isStandard: BoosterSetsMapper.checkLegality(legality: legalities["standard"]),
                isExpanded: BoosterSetsMapper.checkLegality(legality: legalities["expanded"])),
            releaseDate: format.date(from: "2021/08/27")!,
            images: BoosterImage(symbol: url, logo: url))
        
        let json = [
            "id": id,
            "name": "Booster \(id)",
            "series": "Series \(id)",
            "printedTotal": 10,
            "total": 10,
            "legalities": legalities,
            "ptcgoCode": "ptcgoCode \(id)",
            "releaseDate":"2021/08/27",
            "images": [
                "symbol": url.absoluteString,
                "logo": url.absoluteString
            ]
        ].compactMapValues { $0 }
        
        return (boosterSet, json)
    }
}
