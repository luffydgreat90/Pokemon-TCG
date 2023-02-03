//
//  DeckPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public enum DeckPresenter {
    public static func map(_ deck: Deck, dateFormatter: DateFormatter) -> DeckViewModel {
        DeckViewModel(
            name: deck.name,
            update: dateFormatter.string(from: deck.update))
    }
}

