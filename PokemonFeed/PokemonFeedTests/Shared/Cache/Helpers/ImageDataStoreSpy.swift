//
//  ImageDataStoreSpy.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation
import PokemonFeed

class ImageDataStoreSpy: ImageDataStore {
    enum ImageData: Equatable {
        case insert(data: Data, for: URL)
        case retrieve(dataFor: URL)
    }

    private(set) var receivedImages = [ImageData]()
    private var retrievalResult: Result<Data?, Error>?
    private var insertionResult: Result<Void, Error>?

    func insert(_ data: Data, for url: URL) throws {
        receivedImages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }

    func retrieve(dataForURL url: URL) throws -> Data? {
        receivedImages.append(.retrieve(dataFor: url))
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }

    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalResult = .success(data)
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}
