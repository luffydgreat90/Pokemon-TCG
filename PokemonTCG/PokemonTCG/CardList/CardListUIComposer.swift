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

//public enum CardListUIComposer {
//
//    private typealias CardListPresentationAdapter = LoadResourcePresentationAdapter<[Card], BoosterSetsViewAdapter>
//
//    public static func cardListComposedWith(
//        cardList: @escaping () -> AnyPublisher<[Card], Error>,
//        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
//
//            let collectionViewController = CollectionListViewController()
//
//            collectionViewController.configureCollectionView = { collectionView in
//                collectionView.register(CardCollectionCell.self)
//
//            }
//            return collectionViewController
//        }
//}
