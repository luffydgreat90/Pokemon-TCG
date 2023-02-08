//
//  DeckSnapshotTests.swift
//  PokemoniOSTests
//
//  Created by Marlon Ansale on 2/8/23.
//

import Foundation

import XCTest
import PokemoniOS
@testable import PokemonFeed

final class DeckSnapshotTests: XCTestCase {

    func test_boosterSetsWithImage() {
        let sut = makeSUT()
        sut.display(decks())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "DECKS_WITH_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "DECKS_WITH_IMAGE_dark")
    }
    
    func decks() -> [CellController] {
        let deck1 = DeckController(viewModel: DeckViewModel(name: "Deck 1", update: "November 1 2022")) { }
        let deck2 = DeckController(viewModel: DeckViewModel(name: "Deck 2", update: "November 15 2022")) { }
        
        return [CellController(deck1), CellController(deck2)]
    }
    
    // MARK: - Helpers
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.configureTableView = { tableView in
            tableView.register(DeckCell.self)
        }
        controller.loadViewIfNeeded()
        controller.tableView.separatorStyle = .none
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
}
