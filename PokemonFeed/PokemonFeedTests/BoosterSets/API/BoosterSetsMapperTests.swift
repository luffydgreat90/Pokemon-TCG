//
//  BoosterSetsMapperTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/3/23.
//

import PokemonFeed
import XCTest

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
                       legalities: BoosterLegalities(isUnlimited: checkLegality(legality: $0.legalities.unlimited), isStandard: checkLegality(legality: $0.legalities.standard), isExpanded: checkLegality(legality: $0.legalities.expanded)),
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
            legalities: BoosterLegalities(
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
