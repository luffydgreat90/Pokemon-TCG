//
//  UIRefreshControl+TestHelpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
