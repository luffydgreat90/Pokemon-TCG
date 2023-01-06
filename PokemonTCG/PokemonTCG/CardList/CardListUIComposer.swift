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
            let adapter = CardListPresentationAdapter(loader: cardList)
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width:110, height: 200)
            flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            
            let collectionViewController = CollectionListViewController(
                collectionViewLayout: flowLayout,
                onRefresh: { [adapter] in
                    adapter.loadResource()
                }) { collectionView in
                    collectionView.register(CardCollectionCell.self)
                }
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: CardListViewAdapter(
                    controller: collectionViewController,
                    imageLoader: imageLoader),
                loadingView: WeakRefVirtualProxy(collectionViewController),
                errorView: WeakRefVirtualProxy(collectionViewController),
                mapper: CardsPresenter.map)
            
            adapter.loadResource()

            return collectionViewController
        }
}

final class CardListViewAdapter: ResourceView {
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CardController>>
    
    private weak var controller: CollectionListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    
    init(controller: CollectionListViewController? = nil, imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: CardsViewModel) {
        
        let viewControllers = viewModel.cards.map({ model in
            
            
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.images!.small)
            })
            
            let controller = CardController(
                viewModel: CardPresenter.map(model),
                delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(controller),
                loadingView: WeakRefVirtualProxy(controller),
                errorView: WeakRefVirtualProxy(controller),
                mapper: UIImage.tryMake(data:))
            
            return CollectionController(id: model, dataSource: controller)
        })
        
        controller?.display(viewControllers)
        
    }
}
