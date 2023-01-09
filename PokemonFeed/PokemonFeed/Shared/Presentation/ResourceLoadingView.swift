//
//  ResourceLoadingView.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
    
    public static var notLoading: ResourceLoadingViewModel {
        return ResourceLoadingViewModel(isLoading: false)
    }
    
    public static var loading: ResourceLoadingViewModel {
        return ResourceLoadingViewModel(isLoading: true)
    }
}
