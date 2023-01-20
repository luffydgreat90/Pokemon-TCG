//
//  BoosterSetUIIntegrationTests+LoaderSpy.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import Foundation
import PokemonFeed
import PokemoniOS
import Combine

extension BoosterSetUIIntegrationTests {
    final class LoaderSpy {
    
        private var boosterSetRequests = [PassthroughSubject<Paginated<BoosterSet>, Error>]()
    
        var loadBoosterSetCallCount: Int {
            return boosterSetRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<Paginated<BoosterSet>, Error> {
            let publisher = PassthroughSubject<Paginated<BoosterSet>, Error>()
            boosterSetRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeBoosterSetLoading(with boosterSets: [BoosterSet] = [], at index: Int = 0) {
            boosterSetRequests[index].send(Paginated(items: boosterSets, loadMorePublisher: { [weak self] in
                self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
            }))
            boosterSetRequests[index].send(completion: .finished)
        }
        
        func completeBoosterSetLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            boosterSetRequests[index].send(completion: .failure(error))
        }
        
        // MARK: - LoadMoreFeedLoader
        
        private var loadMoreRequests = [PassthroughSubject<Paginated<BoosterSet>, Error>]()
        
        var loadMoreCallCount: Int {
            return loadMoreRequests.count
        }
        
        func loadMorePublisher() -> AnyPublisher<Paginated<BoosterSet>, Error> {
            let publisher = PassthroughSubject<Paginated<BoosterSet>, Error>()
            loadMoreRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeLoadMore(with boosterSets: [BoosterSet] = [], lastPage: Bool = false, at index: Int = 0) {
            loadMoreRequests[index].send(
                Paginated(
                    items: boosterSets,
                    loadMorePublisher: lastPage ? nil : { [weak self] in
                        self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
            }))
            
            loadMoreRequests[index].send(completion: .finished)
        }

        func completeLoadMoreWithError(at index: Int = 0) {
            loadMoreRequests[index].send(completion: .failure(anyNSError()))
        }
        
        // MARK: - ImageDataLoader
        
        private var imageRequests =  [(url: URL, publisher: PassthroughSubject<Data, Error>)]()
        private(set) var cancelledImageURLs = [URL]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        func loadImageData(from url: URL?) -> AnyPublisher<Data, Error>  {
            guard let url = url else{
                return Future { complete in
                    complete(.failure(LocalImageDataLoader.LoadError.notFound))
                }.eraseToAnyPublisher()
            }
            
            let publisher = PassthroughSubject<Data, Error>()
            imageRequests.append((url, publisher))
            return publisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledImageURLs.append(url)
            }).eraseToAnyPublisher()
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].publisher.send(imageData)
            imageRequests[index].publisher.send(completion: .finished)
        }

        func completeImageLoadingWithError(at index: Int = 0) {
            imageRequests[index].publisher.send(completion: .failure(anyNSError()))
        }
    }
}
