//
//  CardUIIntegrationTests+LoaderSpy.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/11/23.
//

import XCTest
import UIKit
import PokemonTCG
import PokemonFeed
import PokemoniOS
import Combine

extension CardUIIntegrationTests {
    final class LoaderSpy: ImageDataLoader {
        private var requests = [PassthroughSubject<[Card], Error>]()
        
        var loadCardCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<[Card], Error> {
            let publisher = PassthroughSubject<[Card], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeCardLoading(with cards: [Card] = [], at index: Int = 0) {
            requests[index].send(cards)
        }

        func completeCardLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
        
        // MARK: - ImageDataLoader
        
        private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()
        private(set) var cancelledImageURLs = [URL]()
        
        private struct TaskSpy: ImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        func loadImageData(from url: URL?, completion: @escaping (Result<Data, Error>) -> Void) -> PokemonFeed.ImageDataLoaderTask {
            
            guard let url = url else{
                return TaskSpy {}
            }
            
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
    }
}
