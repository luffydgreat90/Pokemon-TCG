//
//  CardDetailViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/25/23.
//

import Foundation

public struct CardDetailViewModel {
    public let name: String
    public let supertype: String
    public let number: String
    public let artist: String
    public let averageSellPrice: String
    public let trendPrice: String
    public let lowPrice: String
    public let baseSetName: String
    public let flavorText: String
    
    public init(name: String, supertype: String, number: String, artist: String, averageSellPrice: String, trendPrice: String, lowPrice: String, baseSetName: String, flavorText: String) {
        self.name = name
        self.supertype = supertype
        self.number = number
        self.artist = artist
        self.averageSellPrice = averageSellPrice
        self.trendPrice = trendPrice
        self.lowPrice = lowPrice
        self.baseSetName = baseSetName
        self.flavorText = flavorText
    }
}
