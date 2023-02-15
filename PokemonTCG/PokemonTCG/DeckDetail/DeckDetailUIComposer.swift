//
//  DeckDetailUIComposer.swift
//  PokemonTCG
//
//  Created by Marlon Von Bernales Ansale on 15/02/2023.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

public final class DeckDetailUIComposer {
    private typealias DeckListPresentationAdapter = LoadResourcePresentationAdapter<[SaveCard], DeckDetailAdapter>
    
    public static func deckDetailComposedWith(
        saveCardsLoader: @escaping () -> AnyPublisher<[SaveCard], Error>,
        deck: Deck
    ){
        
    }
}

fileprivate final class DeckDetailAdapter: ResourceView {
    func display(_ viewModel: [SaveCard]) {
        
    }
}
