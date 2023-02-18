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
        deck: Deck,
        priceFormatter: NumberFormatter,
        saveCardsLoader: @escaping () -> AnyPublisher<[SaveCard], Error>,
        imageLoader: @escaping (URL?) -> AnyPublisher<Data, Error>,
        selection: @escaping (SaveCard) -> Void
    ) -> CollectionListViewController {
        let adapter = DeckListPresentationAdapter(loader: saveCardsLoader)
        let collectionViewController = CollectionListViewController(
            collectionViewLayout: CardCollectionLayout())
        
        collectionViewController.configureCollectionView = { collectionView in
            collectionView.register(CardCollectionCell.self)
        }
        
        adapter.presenter = LoadResourcePresenter(
            resourceView: DeckDetailAdapter(
                controller: collectionViewController,
                imageLoader: imageLoader,
                selection: selection,
                priceFormatter: priceFormatter),
            loadingView: WeakRefVirtualProxy(collectionViewController),
            errorView: WeakRefVirtualProxy(collectionViewController))
        
        return collectionViewController
    }
}

fileprivate final class DeckDetailAdapter: ResourceView {
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CardController>>
    
    private weak var controller: CollectionListViewController?
    private let imageLoader: (URL?) -> AnyPublisher<Data, Error>
    private let selection: (SaveCard) -> Void
    private let priceFormatter: NumberFormatter
    
    init(
        controller: CollectionListViewController? = nil,
        imageLoader: @escaping (URL?) -> AnyPublisher<Data, Error>,
        selection: @escaping (SaveCard) -> Void,
        priceFormatter: NumberFormatter) {
            self.controller = controller
            self.imageLoader = imageLoader
            self.selection = selection
            self.priceFormatter = priceFormatter
    }
    
    func display(_ viewModel: [SaveCard]) {
        
    }
}
