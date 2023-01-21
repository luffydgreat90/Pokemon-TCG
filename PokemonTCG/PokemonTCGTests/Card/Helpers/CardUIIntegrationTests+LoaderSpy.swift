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
        let imageLoader = ImageLoaderSpy()
        
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
            requests[index].send(completion: .finished)
        }

        func completeCardLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
    }
}
