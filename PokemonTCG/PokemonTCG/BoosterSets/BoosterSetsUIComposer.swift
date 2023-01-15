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
   
    private typealias BoosterSetsPresentationAdapter = LoadResourcePresentationAdapter<Paginated<BoosterSet>, BoosterSetsViewAdapter>
    
    public static func boosterSetsComposedWith(
        boosterSetsLoader: @escaping () -> AnyPublisher<Paginated<BoosterSet>, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (BoosterSet) -> Void) -> ListViewController {
            let presentationAdapter = BoosterSetsPresentationAdapter(loader: boosterSetsLoader)
            
            let listViewController = ListViewController()
            
            listViewController.configureTableView = { tableView in
                tableView.register(BoosterSetCell.self)
            }
            
            listViewController.title = BoosterSetsPresenter.title
        
            presentationAdapter.presenter = LoadResourcePresenter(
                resourceView: BoosterSetsViewAdapter(
                    controller: listViewController,
                    imageLoader: imageLoader,
                    selection: selection),
                loadingView: WeakRefVirtualProxy(listViewController),
                errorView: WeakRefVirtualProxy(listViewController),
                mapper: { $0 })
            
            listViewController.onRefresh = presentationAdapter.loadResource
            
            return listViewController
    }
}

final class BoosterSetsViewAdapter: ResourceView {
    
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<BoosterSetController>>
    
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> AnyPublisher<Data, Error>
    private let selection: (BoosterSet) -> Void
    
    init(controller: ListViewController? = nil,
         imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
         selection: @escaping (BoosterSet) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<BoosterSet>) {
        
        let dateFormatter = DateFormatter.monthDayYear
        
        let viewControllers = viewModel.items.map({ model in
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                imageLoader(model.images.symbol)
            })
            
            let controller = BoosterSetController(
                viewModel: BoosterSetPresenter.map(
                    model,dateFormat: dateFormatter),
                    delegate: adapter) { [selection] in
                        selection(model)
                    }
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(controller),
                loadingView: WeakRefVirtualProxy(controller),
                errorView: WeakRefVirtualProxy(controller),
                mapper: UIImage.tryMake)
            
            return CellController(id: model, controller)
        })
        
        controller?.display(viewControllers)
    }
}
