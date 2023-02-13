//
//  LocalCard+Helpers.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 13/02/2023.
//

import Foundation

public extension LocalCard {
    func toCard() -> Card {
        let images: CardImages? = self.images != nil ? CardImages(small: self.images!.small, large: self.images!.large) : nil
        
        return Card(
            id: self.id,
            name: self.name,
            supertype: self.supertype,
            number: self.number,
            rarity: self.rarity,
            flavorText: self.flavorText,
            legalities: Legalities(isUnlimited: self.legalities.isUnlimited, isStandard: self.legalities.isStandard, isExpanded: self.legalities.isExpanded),
            artist: self.artist,
            cardmarket: getCardMarket(cardmarket: self.cardmarket),
            images: images,
            cardSet: CardSet(id: self.cardSet.id, name: self.cardSet.name, series: self.cardSet.series)
        )
    }
    
    private func getCardMarket(cardmarket: LocalCardMarket?) -> CardMarket? {
        guard let cardmarket = cardmarket else {
            return nil
        }
        
        return CardMarket(
            url: cardmarket.url,
            updatedAt: cardmarket.updatedAt,
            prices: CardPrice(
                averageSellPrice: cardmarket.prices.averageSellPrice,
                lowPrice: cardmarket.prices.lowPrice,
                trendPrice: cardmarket.prices.trendPrice,
                reverseHoloTrend: cardmarket.prices.reverseHoloTrend)
        )
    }
            
}
