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

    private var deletionCompletions = [String: DeletionCompletion]()
    private var insertionCompletions = [String: InsertionCompletion]()
    private var retrievalCompletions = [String: RetrievalCompletion]()
    
    func deleteCachedCards(setId: String, completion: @escaping DeletionCompletion){
        deletionCompletions[setId] = completion
        receivedCards.append(.deleteCachedCard(setId))
    }

    func completeDeletion(with error: Error, setId: String) {
        deletionCompletions[setId]!(.failure(error))
    }
    
    func completeDeletionSuccessfully(setId: String) {
        deletionCompletions[setId]!(.success(()))
    }
    
    func insert(_ cards: [LocalCard], setId: String, timestamp: Date, completion: @escaping InsertionCompletion){
        insertionCompletions[setId] = completion
        receivedCards.append(.insert(cards, setId, timestamp))
    }

    func retrieve(setID setId: String, completion: @escaping RetrievalCompletion){
        retrievalCompletions[setId] = completion
        receivedCards.append(.retrieve(setId))
    }
    
    func completeRetrievalError(with error: Error, setID: String) {
        retrievalCompletions[setID]!(.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(with error: Error, setID: String) {
        retrievalCompletions[setID]!(.failure(error))
    }
     
    func completeRetrieval(with feed: [LocalCard], setID: String, timestamp: Date) throws {
        guard let completion = retrievalCompletions[setID] else{
            throw CardsNotFound()
        }
        
        completion(.success(CachedCard(cards: feed, setID: setID, timestamp: timestamp)))
    }
    
}
