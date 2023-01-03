//
//  BoosterSetViewModel.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public struct BoosterSetViewModel {
    public let image: URL
    public let title: String
    
    init(image: URL, title: String) {
        self.image = image
        self.title = title
    }
}
