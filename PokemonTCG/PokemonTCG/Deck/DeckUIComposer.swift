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

public final class DeckUIComposer {
    private typealias DeckListPresentationAdapter = LoadResourcePresentationAdapter<[Deck], DeckViewAdapter>
    
    public static func cardDeckComposedWith(
        decksLoader: @escaping () -> AnyPublisher<[Deck], Error>,
        newDeck: @escaping () -> Void,
        selection: @escaping (Deck) -> Void
    ) -> ListViewController {
        let listViewController = ListViewController()
        
        listViewController.configureTableView = { tableView in
            tableView.register(DeckCell.self)
        }
        
        listViewController.title = DeckPresenter.title
        listViewController.addNavigationRightButton(title: "Add")
        
        listViewController.rightButtonTapped = newDeck
        
        let adapter = DeckListPresentationAdapter(loader: decksLoader)
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: DeckViewAdapter(controller: listViewController, dateFormatter: DateFormatter.monthDayYear, selection: selection),
            loadingView: WeakRefVirtualProxy(listViewController),
            errorView: WeakRefVirtualProxy(listViewController),
            mapper:  DeckPresenter.map )
        
        
        return listViewController
    }
}

fileprivate final class DeckViewAdapter: ResourceView {
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
            let view = DeckController(
                viewModel: DeckViewModel(name: model.name, update: dateFormatter.string(from: model.update))) { [selection] in
                selection(model)
            }
            
            return CellController(id: model, view)
        })
    }
}
