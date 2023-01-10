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
    class LoaderSpy: ImageDataLoader {
        
        private var boosterSetRequests = [PassthroughSubject<[BoosterSet], Error>]()
        private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()
        private(set) var cancelledImageURLs = [URL]()
        
        var loadBoosterSetCallCount: Int {
            return boosterSetRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[BoosterSet], Error> {
            let publisher = PassthroughSubject<[BoosterSet], Error>()
            boosterSetRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeFeedLoading(with feed: [BoosterSet] = [], at index: Int = 0) {
            boosterSetRequests[index].send(feed)
        }

        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            boosterSetRequests[index].send(completion: .failure(error))
        }
    }
    
    private struct TaskSpy: ImageDataLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }
}
