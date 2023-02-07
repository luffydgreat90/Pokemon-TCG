//
//  DeckPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 2/3/23.
//

import Foundation

public struct DecksViewModel {
    public let decks: [Deck]
}

public final class DeckPresenter {
    public static func map(_ decks: [Deck]) -> DecksViewModel {
        DecksViewModel(decks: decks)
    }
}

