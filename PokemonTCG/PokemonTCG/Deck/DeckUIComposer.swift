//
//  DeckUIComposer.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 2/6/23.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

public enum DeckUIComposer {
    private typealias DeckListPresentationAdapter = LoadResourcePresentationAdapter<[Deck], DeckViewAdapter>
    
    public static func cardDeckComposedWith(
        decksLoader: @escaping () -> AnyPublisher<[Deck], Error>,
        selection: @escaping (Deck) -> Void
    ) -> ListViewController {
        let listViewController = ListViewController()
        
        let adapter = DeckListPresentationAdapter(loader: decksLoader)
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: DeckViewAdapter(controller: listViewController, dateFormatter: DateFormatter.monthDayYear, selection: selection),
            loadingView: listViewController,
            errorView: listViewController,
            mapper:  DeckPresenter.map )
        
        return listViewController
    }
}

final class DeckViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let selection: (Deck) -> Void
    private let dateFormatter: DateFormatter
    
    init(controller: ListViewController,
         dateFormatter: DateFormatter,
         selection: @escaping (Deck) -> Void) {
        self.controller = controller
        self.selection = selection
        self.dateFormatter = dateFormatter
    }
    
    func display(_ viewModel: DecksViewModel) {
        controller?.display(viewModel.decks.map { model in
            let view = DeckController(viewModel: DeckViewModel(name: model.name, update: dateFormatter.string(from: model.update))) {
                
            }
            
            return CellController(id: model, view)
        })
    }
}
