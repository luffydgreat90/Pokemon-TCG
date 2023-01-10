//
//  UIControl+TestHelpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

