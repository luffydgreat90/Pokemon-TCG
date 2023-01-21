//
//  BoosterSetsEndPoint.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public enum BoosterSetsEndPoint {
    public static let pageSize: Int = 50
    
    case get(totalItems:Int = 0)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(totalItems):
            let ceilItems = ceil(Double(totalItems) / Double(BoosterSetsEndPoint.pageSize))
            let page: Int = Int(ceilItems) + 1
            
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v2/sets"
            components.queryItems = [
                URLQueryItem(name: "pageSize", value: "\(BoosterSetsEndPoint.pageSize)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            return components.url!
        }
    }
}
