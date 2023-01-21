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
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "COLLECTION_LIST_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "COLLECTION_LIST_WITH_ERROR_MESSAGE_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "COLLECTION_LIST_WITH_ERROR_MESSAGE_light_extraExtraExtraLarge")
    }
    // MARK: - Helpers

    private func makeSUT() -> CollectionListViewController {
        let controller = CollectionListViewController(
            collectionViewLayout: CardCollectionLayout())
        controller.loadViewIfNeeded()
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CollectionController] {
        return []
    }
}
