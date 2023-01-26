//
//  CardListViewAdapter.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/25/23.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

final class CardListViewAdapter: ResourceView {
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CardController>>
    
    private weak var controller: CollectionListViewController?
    private let imageLoader: (URL?) -> AnyPublisher<Data, Error>
    private let selection: (Card) -> Void
    private lazy var cancelable = Set<AnyCancellable>()
    private let priceFormatter: NumberFormatter
    
    init(controller: CollectionListViewController? = nil,
         imageLoader: @escaping (URL?) -> AnyPublisher<Data, Error>,
         selection: @escaping (Card) -> Void,
         priceFormatter: NumberFormatter) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
        self.priceFormatter = priceFormatter
    }
    
    func display(_ viewModel: CardsViewModel) {
        let viewControllers = toCollectionController(with: viewModel.cards, priceFormatter: priceFormatter)
        controller?.display(viewControllers)
    }
    
    private func toCollectionController(with cards: [Card], priceFormatter: NumberFormatter) -> [CollectionController] {
        cards.map({ model in
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.images?.small)
            })
            
            let controller = CardController(
                viewModel: CardPresenter.map(model, currencyFormatter: priceFormatter),
                delegate: adapter,
                selection: { [selection] in
                    selection(model)
                })
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(controller),
                loadingView: WeakRefVirtualProxy(controller),
                errorView: WeakRefVirtualProxy(controller),
                mapper: UIImage.tryMake(data:))
            
            return CollectionController(id: model, dataSource: controller, delegate: controller)
        })
    }
}
