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
        
        func loadPublisher() -> AnyPublisher<[BoosterSet], Error> {
            let publisher = PassthroughSubject<[BoosterSet], Error>()
            boosterSetRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
    }
    
    private struct TaskSpy: ImageDataLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }
}
