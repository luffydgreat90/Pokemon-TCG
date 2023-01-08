//
//  CardsTestHelpers.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/8/23.
//

import Foundation
import PokemonFeed

func uniqueCard(name:String = "Charmander", supertype:SuperType = .pokemon, number:String = "1", rarity:String? = "Common", flavorText:String? = nil, artist:String? = "John Doe") -> Card {
    let id = UUID().uuidString
    
    return Card(
        id: id,
        name: "",
        supertype: supertype,
        number: number,
        rarity: rarity,
        flavorText: flavorText,
        legalities: Legalities(isUnlimited: true , isStandard: false, isExpanded: false),
        artist: artist,
        cardmarket: CardMarket(
            url: anyURL(),
            updatedAt: Date(),
            prices: CardPrice(averageSellPrice: 5.0, lowPrice: 1.0, trendPrice: 3.0, reverseHoloTrend: 5.0)),
        images: CardImages(small: anyURL(), large: anyURL()),
        cardSet: CardSet(id: id, name: "Base \(id)", series: "Series \(id)"))
}
