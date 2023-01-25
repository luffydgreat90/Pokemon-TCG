//
//  CardDetailPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/25/23.
//

import Foundation

public enum CardDetailPresenter{
    public static func map(_ card: Card, currencyFormatter: NumberFormatter) -> CardDetailViewModel {
        CardDetailViewModel(
            name: card.name,
            supertype: "Type: \(card.supertype.rawValue)",
            number: "#\(card.number)",
            artist: "Artist: \(card.artist ?? "N/A")",
            averageSellPrice: "Average: \(currencyFormatter.getPrice(price: card.cardmarket?.prices.averageSellPrice))",
            trendPrice: "Trend: \(currencyFormatter.getPrice(price: card.cardmarket?.prices.trendPrice))",
            lowPrice: "Low: \(currencyFormatter.getPrice(price: card.cardmarket?.prices.lowPrice))",
            baseSetName: card.cardSet.name,
            flavorText: card.flavorText ?? "")
    }
}
