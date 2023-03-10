//
//  BoosterSetViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public struct BoosterSetViewModel {
    public let title: String
    public let totalCards: String
    public let releaseDate: String
    
    public init(title: String, totalCards: String, releaseDate: String) {
        self.title = title
        self.totalCards = totalCards
        self.releaseDate = releaseDate
    }
}
