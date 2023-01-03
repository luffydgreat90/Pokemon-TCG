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
    let isUnlimited: Bool
    let isStandard: Bool
    let isExpanded: Bool
}

public struct BoosterImage {
    let symbol: URL
    let logo: URL
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
}
