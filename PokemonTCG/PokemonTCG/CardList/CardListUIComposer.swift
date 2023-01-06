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
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) -> CollectionListViewController{
            let collectionViewController = CollectionListViewController()

            let adapter = CardListPresentationAdapter(loader: cardList)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: CardListViewAdapter(
                    controller: collectionViewController,
                    imageLoader: imageLoader),
                loadingView: WeakRefVirtualProxy(collectionViewController),
                errorView: WeakRefVirtualProxy(collectionViewController),
                mapper: CardsPresenter.map)
            
            collectionViewController.configureCollectionView = { collectionView in
                collectionView.register(CardCollectionCell.self)
            }

            return collectionViewController
        }
}

final class CardListViewAdapter: ResourceView {
    
    private weak var controller: CollectionListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    init(controller: CollectionListViewController? = nil, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: CardsViewModel) {
        
        
    }
}
