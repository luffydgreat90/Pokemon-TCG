//
//  SuperTypeTests.swift
//  PokemonFeedTests
//
//  Created by Marlon Ansale on 1/7/23.
//

import XCTest
import PokemonFeed

final class SuperTypeTests: XCTestCase {
    func test_superType_invalid() {
        let types = ["Trainers","Pokemon","energy","ENERGY",""]
        
        types.forEach { type in
            XCTAssertEqual(SuperType.checkSupertype(type), .unknown)
        }
    }
    
    func test_superType_valid() {
        XCTAssertEqual(SuperType.checkSupertype("Trainer"), .trainer)
        XCTAssertEqual(SuperType.checkSupertype("Pokémon"), .pokemon)
        XCTAssertEqual(SuperType.checkSupertype("Energy"), .energy)
    }
    
    func test_superTypeString(){
        XCTAssertEqual(SuperType.unknown.rawValue, "")
        XCTAssertEqual(SuperType.trainer.rawValue, "Trainer")
        XCTAssertEqual(SuperType.pokemon.rawValue, "Pokémon")
        XCTAssertEqual(SuperType.energy.rawValue, "Energy")
    }
}
