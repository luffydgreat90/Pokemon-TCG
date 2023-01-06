//
//  LoadResourcePresentationAdapter.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/3/23.
//

import Combine
import Foundation
import PokemonFeed
import PokemoniOS

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, View>?
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .finished: break

                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
            }, receiveValue: {  [weak self] resource in
                
                self?.presenter?.didFinishLoading(with: resource)
            })
        
    }

}

extension LoadResourcePresentationAdapter: ImageControllerDelegate {
    func didRequestImage() {
        self.loadResource()
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
