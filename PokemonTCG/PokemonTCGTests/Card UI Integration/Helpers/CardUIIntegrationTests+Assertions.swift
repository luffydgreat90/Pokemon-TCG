//
//  CardUIIntegrationTests+Assertions.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/11/23.
//

import XCTest
import PokemonFeed
import PokemoniOS

extension CardUIIntegrationTests {
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}

