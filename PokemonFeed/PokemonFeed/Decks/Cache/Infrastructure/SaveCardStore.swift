//
//  SaveCardStore.swift
//  PokemonFeed
//
//  Created by Marlon Von Bernales Ansale on 16/02/2023.
//

import Foundation

public protocol SaveCardStore {
    func insert(_ card: LocalCard) throws
    func remove(_ saveCard: LocalSaveCard) throws
    func retrieve() throws -> [LocalSaveCard]
}
