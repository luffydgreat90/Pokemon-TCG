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
    final class LoaderSpy: ImageDataLoader {
        
        private var boosterSetRequests = [PassthroughSubject<[BoosterSet], Error>]()
    
        var loadBoosterSetCallCount: Int {
            return boosterSetRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[BoosterSet], Error> {
            let publisher = PassthroughSubject<[BoosterSet], Error>()
            boosterSetRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        
        func completeBoosterSetLoading(with boosterSets: [BoosterSet] = [], at index: Int = 0) {
            boosterSetRequests[index].send(boosterSets)
        }

        func completeBoosterSetLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            boosterSetRequests[index].send(completion: .failure(error))
        }
        
        // MARK: - ImageDataLoader
        
        private struct TaskSpy: ImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        
        private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()

        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }

        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
        
        private(set) var cancelledImageURLs = [URL]()
    }
}
