//
//  DeckDetailPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 15/02/2023.
//

import Foundation

public final class DeckDetailPresenter {
    public static func map(_ saveCard: [SaveCard], priceFormat: NumberFormatter) -> [SaveCardViewModel] {
         saveCard.map { saveCard in
            SaveCardViewModel(
                name: saveCard.card.name,
                quantity: saveCard.quantity,
                type: saveCard.card.supertype.rawValue,
                price: priceFormat.getPrice(price: saveCard.card.cardmarket?.prices.trendPrice))
        }
    }
}
