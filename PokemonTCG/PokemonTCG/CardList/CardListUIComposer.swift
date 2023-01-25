//
//  CardListUIComposer.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/5/23.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

public enum CardListUIComposer {

    private typealias CardListPresentationAdapter = LoadResourcePresentationAdapter<[Card], CardListViewAdapter>

    public static func cardListComposedWith(
        cardList: @escaping () -> AnyPublisher<[Card], Error>,
        imageLoader: @escaping (URL?) -> AnyPublisher<Data, Error>,
        selection: @escaping (Card) -> Void) -> CollectionListViewController{
            let adapter = CardListPresentationAdapter(loader: cardList)
            
            let collectionViewController = CollectionListViewController(
                collectionViewLayout: CardCollectionLayout())
            
            collectionViewController.configureCollectionView = { collectionView in
                collectionView.register(CardCollectionCell.self)
            }
            
            collectionViewController.onRefresh = adapter.loadResource
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: CardListViewAdapter(
                    controller: collectionViewController,
                    imageLoader: imageLoader,
                    selection: selection),
                loadingView: WeakRefVirtualProxy(collectionViewController),
                errorView: WeakRefVirtualProxy(collectionViewController),
                mapper: CardsPresenter.map)
            
            return collectionViewController
        }
}

final class CardListViewAdapter: ResourceView {
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CardController>>
    
    private weak var controller: CollectionListViewController?
    private let imageLoader: (URL?) -> AnyPublisher<Data, Error>
    private let selection: (Card) -> Void
    
    init(controller: CollectionListViewController? = nil,
         imageLoader: @escaping (URL?) -> AnyPublisher<Data, Error>,
         selection: @escaping (Card) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: CardsViewModel) {
        let priceFormatter: NumberFormatter = .priceFormatter
        
        let viewControllers = viewModel.cards.map({ model in
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
        
        controller?.display(viewControllers)
        
    }
}
