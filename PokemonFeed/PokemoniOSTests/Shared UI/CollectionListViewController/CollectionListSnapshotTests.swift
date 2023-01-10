//
//  CollectionListSnapshotTests.swift
//  PokemoniOSTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import XCTest
import PokemoniOS
@testable import PokemonFeed

final class CollectionListSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()

        sut.display(emptyList())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_COLLECTION_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_COLLECTION_LIST_dark")
    }
    
    // MARK: - Helpers

    private func makeSUT() -> CollectionListViewController {
        let controller = CollectionListViewController(
            collectionViewLayout: UICollectionViewFlowLayout(),
            onRefresh: nil,
            configureCollectionView: {_ in
            
        })
        controller.loadViewIfNeeded()
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CollectionController] {
        return []
    }
}
