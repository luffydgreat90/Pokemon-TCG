//
//  LocalSaveCardLoader.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 16/02/2023.
//

import Foundation

public final class LocalSaveCardLoader {
    private let store: SaveCardStore
    private let currentDate: () -> Date
    
    public init(store: SaveCardStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalSaveCardLoader {
    public func load() throws -> [SaveCard] {
        return []
    }
}
