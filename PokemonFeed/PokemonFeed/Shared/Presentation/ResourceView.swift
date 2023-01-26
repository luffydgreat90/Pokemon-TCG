//
//  ResourceView.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/26/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}
