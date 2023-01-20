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
    final class LoaderSpy {
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
