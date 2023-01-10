//
//  ListViewController+TestHelpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import UIKit
import PokemoniOS

extension ListViewController {
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: boosterSetsSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    private var boosterSetsSection: Int { 0 }
}
