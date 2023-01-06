//
//  CardPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import Foundation

public enum CardPresenter {
    public static func map(_ card: Card) -> CardViewModel {
        CardViewModel(name: card.name, price: "$\(card.cardmarket.prices.trendPrice)")
    }
    
}
