//
//  Legalities.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public struct Legalities: Hashable {
    public let isUnlimited: Bool
    public let isStandard: Bool
    public let isExpanded: Bool
    
    public init(isUnlimited: Bool, isStandard: Bool, isExpanded: Bool) {
        self.isUnlimited = isUnlimited
        self.isStandard = isStandard
        self.isExpanded = isExpanded
    }
}
