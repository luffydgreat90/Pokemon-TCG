//
//  CardEndPoint.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public enum CardEndPoint {
    case get(_ id:String)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return URL(string: "\(baseURL.absoluteString)cards?q=set.id:\(id)")!
        }
    }
}
