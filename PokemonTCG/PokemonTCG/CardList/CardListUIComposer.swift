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
        priceFormatter: NumberFormatter,
        selection: @escaping (Card) -> Void) -> CollectionListViewController{
            let adapter = CardListPresentationAdapter(loader: cardList)
            
            let priceFormatter: NumberFormatter = .priceFormatter
            
            let collectionViewController = CollectionListViewController(
                collectionViewLayout: CardCollectionLayout())
            
            let searchController = UISearchController()
            searchController.searchBar.searchTextField.backgroundColor = .lightGray
            searchController.searchBar.showsCancelButton = false
            collectionViewController.navigationItem.searchController = searchController
            collectionViewController.definesPresentationContext = true
            
            collectionViewController.configureCollectionView = { collectionView in
                collectionView.register(CardCollectionCell.self)
            }
            
            collectionViewController.onRefresh = adapter.loadResource
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: CardListViewAdapter(
                    controller: collectionViewController,
                    imageLoader: imageLoader,
                    selection: selection,
                    priceFormatter: priceFormatter),
                loadingView: WeakRefVirtualProxy(collectionViewController),
                errorView: WeakRefVirtualProxy(collectionViewController),
                mapper: CardsPresenter.map)
            
            
            
            
            return collectionViewController
        }
}
