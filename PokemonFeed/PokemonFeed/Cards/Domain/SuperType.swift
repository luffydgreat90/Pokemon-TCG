//
//  SuperType.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/6/23.
//

import Foundation

public enum SuperType {
    case trainer, energy, pokemon, unknown
    
    public static func checkSupertype(_ superType: String) -> SuperType {
        switch superType {
            case "Trainer": return .trainer
            case "Pokémon": return .pokemon
            case "Energy": return .energy
            default: return .unknown
        }
    }
}
