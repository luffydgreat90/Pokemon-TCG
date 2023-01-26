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
            let priceFormatter: NumberFormatter = .priceFormatter
            
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
            
            collectionViewController.searchController.searchBar.searchTextField.textPublisher
                .debounce(for: 0.5, scheduler: DispatchQueue.immediateWhenOnMainQueueScheduler)
                .removeDuplicates()
                .sink { [weak self] search in
                    guard let self = self else { return }
                    let filterCards = viewModel.cards.filter {  $0.name.lowercased().contains(search.lowercased())}
                    let viewControllers = self.toCollectionController(with: filterCards, priceFormatter: priceFormatter)
                    self.controller?.display(viewControllers)
                }.store(in: &cancelable)
            
            return collectionViewController
        }
}
