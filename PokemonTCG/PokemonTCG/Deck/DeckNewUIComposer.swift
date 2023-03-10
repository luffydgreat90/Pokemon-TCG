//
//  DeckNewUIComposer.swift
//  PokemonTCG
//
//  Created by Marlon Von Bernales Ansale on 14/02/2023.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

public final class DeckNewUIComposer {
    public static func newDeckComposed(
        newDeck:@escaping ((String) -> Void)
    ) -> DeckNewViewController {
        let viewController = DeckNewViewController()
        viewController.newDeck = newDeck
        return viewController
    }
}
