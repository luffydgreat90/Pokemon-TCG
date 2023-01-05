//
//  BoosterSetPresenter.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/3/23.
//

import Foundation

public enum BoosterSetPresenter {
    public static func map(_ boosterSet: BoosterSet, dateFormat:DateFormatter) -> BoosterSetViewModel {
        BoosterSetViewModel(
            image: boosterSet.images.symbol,
            title: boosterSet.name,
            totalCards: "Number of Cards: \(boosterSet.printedTotal)",
            releaseDate: dateFormat.string(from: boosterSet.releaseDate))
    }
}
