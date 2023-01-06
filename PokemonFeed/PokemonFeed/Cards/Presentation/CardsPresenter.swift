//
//  CardsPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import Foundation

public final class CardsPresenter {
    public static func map(_ cards: [Card]) -> CardsViewModel {
        CardsViewModel(cards: cards)
    }
}
