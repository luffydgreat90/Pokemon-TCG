//
//  CardViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public struct CardViewModel {
    let image:URL
    let name:String
    
    public init(image: URL, name: String) {
        self.image = image
        self.name = name
    }
}

