//
//  BoosterSetUIIntegrationTests+Assertions.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import XCTest
import PokemonFeed
import PokemoniOS

extension BoosterSetUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering boosterSets: [BoosterSet], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedBoosterSetViews() == boosterSets.count else {
            return XCTFail("Expected \(boosterSets.count) images, got \(sut.numberOfRenderedBoosterSetViews()) instead.", file: file, line: line)
        }
        
        let dateFormat:DateFormatter = .monthDayYear
        boosterSets.enumerated().forEach { index, boosterSet in
            assertThat(sut, hasViewConfiguredFor: BoosterSetPresenter.map(boosterSet, dateFormat: dateFormat), at: index, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    func assertThat(_ sut: ListViewController, hasViewConfiguredFor viewModel: BoosterSetViewModel, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.boosterSetView(at: index)

        guard let cell = view as? BoosterSetCell else {
            return XCTFail("Expected \(BoosterSetCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.titleText, viewModel.title, "Title at index (\(index))", file: file, line: line)
        
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}
