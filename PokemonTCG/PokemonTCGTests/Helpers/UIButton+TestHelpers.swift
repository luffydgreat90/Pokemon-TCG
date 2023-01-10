//
//  UIButton+Helpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit.UIButton

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
