//
//  Combine+Helpers.swift
//  PokemonTCG
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation
import Combine
import PokemonFeed

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>

    func getPublisher(url: URL?) -> Publisher {
        var task: HTTPClientTask?

        return Deferred {
            Future { completion in
                task = self.get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}

extension Publisher where Output == Data {
    func caching(to cache: ImageDataCache, using url: URL?) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { data in
            cache.saveIgnoringResult(data, for: url)
        }).eraseToAnyPublisher()
    }
}

extension Publisher {
    func caching(to cache: BoosterSetCache) -> AnyPublisher<Output, Failure> where Output == [BoosterSet] {
        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
    
    func caching(to cache: BoosterSetCache) -> AnyPublisher<Output, Failure> where Output == Paginated<BoosterSet> {
        handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
    }
}

private extension BoosterSetCache {
    func saveIgnoringResult(_ boosterSets: [BoosterSet]) {
        try? save(boosterSets)
    }
    
    func saveIgnoringResult(_ page: Paginated<BoosterSet>) {
        saveIgnoringResult(page.items)
    }
}

extension Publisher where Output == [Card] {
    func caching(to cache: CardCache, setId: String) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { cards in
            cache.saveIgnoringResult(cards, setId: setId)
        }).eraseToAnyPublisher()
    }
}

private extension CardCache {
    func saveIgnoringResult(_ cards: [Card], setId: String) {
        save(cards, setId: setId) { _ in }
    }
}


public extension LocalBoosterSetLoader {
    typealias Publisher = AnyPublisher<[BoosterSet], Error>

    func loadPublisher() -> Publisher {
        Deferred {
            Future { completion in
                completion(Result{ try self.load() })
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension LocalCardLoader {
    typealias Publisher = AnyPublisher<[Card], Error>

    func loadPublisher(setId: String) -> Publisher {
        return Deferred {
            Future { promise in
                self.load(setID: setId) { result in
                    promise(result)
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

private extension ImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL?) {
        guard let url = url else { return }
        try? save(data, for: url)
    }
}

public extension ImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadImageDataPublisher(from url: URL?) -> Publisher {
        Deferred {
            Future { completion in
                completion(Result{ try self.loadImageData(from: url) })
            }
        }
        .eraseToAnyPublisher()
    }
}

