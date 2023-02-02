//
//  CardStoreSpy.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import XCTest
import PokemonFeed

class CardStoreSpy: CardStore {
    private struct CardsNotFound: Error {}
    
    enum ReceivedCard: Equatable {
        case deleteCachedCard(String)
        case insert([LocalCard], String, Date)
        case retrieve(String)
    }

    private(set) var receivedCards = [ReceivedCard]()

    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedCard?, Error>?
    
    func deleteCachedCards(setId: String) throws {
        receivedCards.append(.deleteCachedCard(setId))
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error, setId: String) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully(setId: String) {
        deletionResult = .success(())
    }
    
    func insert(_ cards: [LocalCard], setId: String, timestamp: Date) throws {
        receivedCards.append(.insert(cards,setId, timestamp))
        try insertionResult?.get()
    }

    func retrieve(setID setId: String)  throws -> CachedCard?{
        receivedCards.append(.retrieve(setId))
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, setID: String) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(with error: Error, setID: String) {
        retrievalResult = .failure(error)
    }
     
    func completeRetrieval(with feed: [LocalCard], setID: String, timestamp: Date) throws {
        retrievalResult = .success(CachedCard(cards: feed, setID: setID, timestamp: timestamp))
    }
    
}
