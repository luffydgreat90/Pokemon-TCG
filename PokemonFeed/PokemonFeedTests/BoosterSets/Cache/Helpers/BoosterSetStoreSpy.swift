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

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()

    func deleteCachedBoosterSet(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedBoosterSets.append(.deleteCachedFeed)
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }

    func insert(_ feed: [LocalBoosterSet], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedBoosterSets.append(.insert(feed, timestamp))
    }

    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }

    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedBoosterSets.append(.retrieve)
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }

    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success(.none))
    }

    func completeRetrieval(with feed: [LocalBoosterSet], timestamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(CachedBoosterSet(boosterSets: feed, timestamp: timestamp)))
    }
}
