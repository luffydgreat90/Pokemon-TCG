//
//  CardDetailUIComposer.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/25/23.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

public enum CardDetailUIComposer {
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<CardDetailViewController>>
    
    public static func cardDetailComposedWith(
        card: Card,
        imageLoader: @escaping (URL?) -> AnyPublisher<Data, Error>,
        openURL: @escaping (URL?) -> Void) -> CardDetailViewController {
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(card.images?.large)
            })
            
            let controller = CardDetailViewController()
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(controller),
                loadingView: WeakRefVirtualProxy(controller),
                errorView: WeakRefVirtualProxy(controller),
                mapper: UIImage.tryMake(data:))
            
            controller.loadImage = { [adapter] in
                adapter.loadResource()
            }
            
            controller.openUrl = { [openURL] in
                openURL(card.cardmarket?.url)
            }
            
            controller.displayCardDetail(CardDetailPresenter.map(card, currencyFormatter: .priceFormatter))
            
            return controller
    }
}
