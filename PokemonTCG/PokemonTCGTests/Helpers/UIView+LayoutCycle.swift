//
//  UIView+LayoutCycle.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit.UIView

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
