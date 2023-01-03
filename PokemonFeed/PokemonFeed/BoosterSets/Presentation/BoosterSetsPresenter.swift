//
//  BoosterSetsPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public final class BoosterSetsPresenter {
    public static var title: String {
        NSLocalizedString(
            "BOOSTER_SET_TITLE",
            tableName: "BoosterSets",
            bundle: Bundle(for: BoosterSetsPresenter.self),
            comment: "Title for the booster set")
    }
    
    public static func map(_ sets: [BoosterSet]) -> BoosterSetsViewModel {
        BoosterSetsViewModel(sets: sets)
    }
}
