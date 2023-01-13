//
//  CardStoreSpy.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/13/23.
//

import Foundation
import PokemonFeed

class CardStoreSpy: CardStore {
    
    func deleteCachedCards(setId: String, completion: @escaping DeletionCompletion){
        
    }

    func insert(_ cards: [LocalCard], setId: String, timestamp: Date, completion: @escaping InsertionCompletion){
        
    }

    func retrieve(setId: String, completion: @escaping RetrievalCompletion){
        
    }
}
