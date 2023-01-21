//
//  ImageDataLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/7/23.
//

import Foundation

public final class LocalImageDataLoader {
    private let store: ImageDataStore

    public init(store: ImageDataStore) {
        self.store = store
    }
}

extension LocalImageDataLoader: ImageDataCache {
    public enum SaveError: Error {
        case failed
    }

    public func save(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}

extension LocalImageDataLoader: ImageDataLoader {
    
    public enum LoadError: Error {
        case invalidURL
        case failed
        case notFound
    }


    public func loadImageData(from url: URL?) throws -> Data {
        guard let url = url else {
            throw LoadError.invalidURL
        }
        
        do {
            if let imageData = try store.retrieve(dataForURL: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        
        throw LoadError.notFound
    }
}
