//
//  CardSnapshotTests.swift
//  PokemoniOSTests
//
//  Created by Marlon Ansale on 1/10/23.
//

import XCTest
import PokemoniOS
@testable import PokemonFeed

final class CardSnapshotTests: XCTestCase {
    func test_CardsWithContent() {
        let sut = makeSUT()

        sut.display(cardsWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CARDS_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CARDS_WITH_CONTENT_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "CARDS_WITH_CONTENT_light_extraExtraExtraLarge")
    }

    // MARK: - Helpers
    
    private func makeSUT() -> CollectionListViewController {
        let controller = CollectionListViewController(
            collectionViewLayout: CardCollectionLayout(),
            onRefresh: nil,
            configureCollectionView: { collectionView in
                collectionView.register(CardCollectionCell.self)
        })
        controller.loadViewIfNeeded()
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func cardsWithContent() -> [ImageStub] {
        return [
            ImageStub(name: "Base", price: "Number of Cards: 102", image: UIImage.make(withColor: .red)),
            ImageStub(name: "Jungle", price: "Number of Cards: 64", image: UIImage.make(withColor: .green))
        ]
    }
}

private extension CollectionListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [CollectionController] = stubs.map { stub in
            let cellController = CardController(viewModel: stub.viewModel, delegate: stub)
            stub.controller = cellController
            return CollectionController(id: UUID(), dataSource: cellController)
        }

        display(cells)
    }
}

fileprivate class ImageStub: ImageControllerDelegate {
    let viewModel: CardViewModel
    let image: UIImage?
    weak var controller: CardController?

    init(name: String, price: String, image: UIImage?){
        self.viewModel =  CardViewModel(name: name, price: price)
        self.image = image
    }
    
    func didRequestImage() {
        controller?.display(ResourceLoadingViewModel(isLoading: false))

        if let image = image {
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(message: .none))
        } else {
            controller?.display(ResourceErrorViewModel(message: "any"))
        }
    }
    
    func didCancelImageRequest() {
        
    }
}
