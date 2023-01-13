//
//  CardStoreSpy.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import Foundation
import PokemonFeed

class CardStoreSpy: CardStore {
    enum ReceivedCard: Equatable {
        case deleteCachedCard(String)
        case insert([LocalCard], String, Date)
        case retrieve(String)
    }

    private(set) var receivedCards = [ReceivedCard]()

    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
    func deleteCachedCards(setId: String, completion: @escaping DeletionCompletion){
        deletionCompletions.append(completion)
        receivedCards.append(.deleteCachedCard(setId))
    }

    func insert(_ cards: [LocalCard], setId: String, timestamp: Date, completion: @escaping InsertionCompletion){
        insertionCompletions.append(completion)
        receivedCards.append(.insert(cards, setId, timestamp))
    }

    func retrieve(setId: String, completion: @escaping RetrievalCompletion){
        retrievalCompletions.append(completion)
        receivedCards.append(.retrieve(setId))
    }
    
    func completeRetrievalError(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
     
    func completeRetrieval(with feed: [LocalCard], setID: String, timestamp: Date, at index: Int = 0) {
        retrievalCompletions[index](.success(CachedCard(cards: feed, setID: setID, timestamp: timestamp)))
    }
}
