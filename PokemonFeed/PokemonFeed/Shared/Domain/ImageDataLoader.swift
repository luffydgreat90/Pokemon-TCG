//
//  ImageDataLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public protocol ImageDataLoader {
    func loadImageData(from url: URL?) throws -> Data
}
