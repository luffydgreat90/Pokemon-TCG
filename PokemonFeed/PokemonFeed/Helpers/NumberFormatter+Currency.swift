//
//  NumberFormatter+Currency.swift
//  PokemonFeed
//
//  Created by Marlon Ansale on 1/25/23.
//

import Foundation

extension NumberFormatter {
    public func getPrice(price: Double?) -> String {
        guard let price = price else {
            return "$0.00"
        }
        
        return string(from: NSNumber(value: price)) ?? "$0.00"
    }
    
    public static var priceFormatter: NumberFormatter {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale =  Locale(identifier: "en_US_POSIX")
        return priceFormatter
    }
}
