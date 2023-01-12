//
//  NumberFormatter+Helpers.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/12/23.
//

import Foundation

extension NumberFormatter {
    public static var priceFormatter: NumberFormatter {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale =  Locale(identifier: "en_US_POSIX")
        return priceFormatter
    }
}

