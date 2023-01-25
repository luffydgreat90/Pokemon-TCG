//
//  BoosterSetStoreSpy.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation
import PokemonFeed

class BoosterSetStoreSpy: BoosterSetStore {
    enum ReceivedBoosterSet: Equatable {
        case deleteCachedFeed
        case insert([LocalBoosterSet], Date)
        case retrieve
    }

    private(set) var receivedBoosterSets = [ReceivedBoosterSet]()
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedBoosterSet?, Error>?

    func deleteCachedBoosterSet() throws {
        receivedBoosterSets.append(.deleteCachedFeed)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }

    func insert(_ boosterSet: [LocalBoosterSet], timestamp: Date) throws {
        receivedBoosterSets.append(.insert(boosterSet, timestamp))
        try insertionResult?.get()
    }

    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }

    func retrieve() throws -> CachedBoosterSet? {
        receivedBoosterSets.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }

    func completeRetrieval(with boosterSets: [LocalBoosterSet], timestamp: Date) {
        retrievalResult = .success(CachedBoosterSet(boosterSets: boosterSets, timestamp: timestamp))
    }
}
