//
//  CardUIIntegrationTests+Helpers.swift
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
        
        func loadPublisher() -> () -> AnyPublisher<[Card], Error> {
            let publisher = PassthroughSubject<[Card], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        // MARK: - ImageDataLoader
        
        func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> ImageDataLoaderTask {
            
        }
    }
}
