//
//  BoosterSetController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit
import PokemonFeed

public final class BoosterSetController: NSObject {
    private let viewModel: BoosterSetViewModel
    
    init(viewModel: BoosterSetViewModel) {
        self.viewModel = viewModel
    }
}
