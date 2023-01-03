//
//  BoosterSetPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public enum BoosterSetPresenter {
    public static func map(_ boosterSet: BoosterSet) -> BoosterSetViewModel {
        BoosterSetViewModel(
            image: boosterSet.images.logo,
            title: boosterSet.name)
    }
}
