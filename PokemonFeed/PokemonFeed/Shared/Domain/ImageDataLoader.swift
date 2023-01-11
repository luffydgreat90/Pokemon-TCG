//
//  ImageDataLoader.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/4/23.
//

import Foundation

public protocol ImageDataLoaderTask {
    func cancel()
}

public protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL?, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask
}
