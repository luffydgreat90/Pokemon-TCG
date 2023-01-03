//
//  BoosterSetsUIComposer.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit
import Combine
import PokemonFeed
import PokemoniOS

public enum BoosterSetsUIComposer {
    
}

final class BoosterSetsViewAdapter: ResourceView {
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<BoosterSetController>>
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Swift.Error>
    
    init(controller: ListViewController? = nil,
         imageLoader: @escaping (URL) -> AnyPublisher<Data, Swift.Error>) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: BoosterSetsViewModel) {
        controller?.display(viewModel.sets.map({ model in
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.images.logo)
            })
            
            let controller = BoosterSetController(viewModel: BoosterSetPresenter.map(model),
                                                  delegate: adapter)
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(controller),
                loadingView: WeakRefVirtualProxy(controller),
                errorView: WeakRefVirtualProxy(controller),
                mapper: UIImage.tryMake)
            
            return CellController(id: model, controller)
        }))
    }
}
