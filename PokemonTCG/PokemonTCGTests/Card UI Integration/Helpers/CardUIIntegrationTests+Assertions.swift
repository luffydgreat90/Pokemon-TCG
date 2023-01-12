//
//  CardUIIntegrationTests+Assertions.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/11/23.
//

import XCTest
import PokemonFeed
import PokemoniOS

extension CardUIIntegrationTests {
    func assertThat(_ sut: CollectionListViewController, isRendering cards: [Card], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedCardViews() == cards.count else {
            return XCTFail("Expected \(cards.count) images, got \(sut.numberOfRenderedCardViews()) instead.", file: file, line: line)
        }
        
        let currencyFormatter: NumberFormatter = .priceFormatter
        cards.enumerated().forEach { [currencyFormatter] index, card in
            assertThat(sut, hasViewConfiguredFor: CardPresenter.map(card, currencyFormatter: currencyFormatter), at: index, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    func assertThat(_ sut: CollectionListViewController, hasViewConfiguredFor viewModel: CardViewModel, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.cardView(at: index)

        guard let cell = view as? CardCollectionCell else {
            return XCTFail("Expected \(CardCollectionCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.titleLabel.text, viewModel.name, "Name at index (\(index))", file: file, line: line)
        XCTAssertEqual(cell.priceLabel.text, viewModel.price, "Price at index (\(index))", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}

