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
    func test_CardsWithImage() {
        let sut = makeSUT()

        sut.display(cardsWithImage())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CARDS_WITH_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CARDS_WITH_IMAGE_dark")
    }
    
    func test_CardsWithoutImage() {
        let sut = makeSUT()

        sut.display(cardsWithoutImage())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CARDS_WITHOUT_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CARDS_WITHOUT_IMAGE_dark")
    }

    // MARK: - Helpers
    
    private func makeSUT() -> CollectionListViewController {
        let controller = CollectionListViewController(collectionViewLayout: CardCollectionLayout(), frame: CGRect(origin: CGPoint(x: 0, y: 0), size: SnapshotConfiguration.iPhone13FrameSize))
        
        controller.configureCollectionView = { collectionView in
            collectionView.register(CardCollectionCell.self)
        }
        
        controller.loadViewIfNeeded()
        controller.collectionView.showsVerticalScrollIndicator = false
        controller.collectionView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func cardsWithImage() -> [ImageStub] {
        return [
            ImageStub(name: "Base", price: "Number of Cards: 102", image: UIImage.make(withColor: .red)),
            ImageStub(name: "Jungle", price: "Number of Cards: 64", image: UIImage.make(withColor: .green))
        ]
    }
    
    private func cardsWithoutImage() -> [ImageStub] {
        return [
            ImageStub(name: "Base", price: "Number of Cards: 102", image: nil),
            ImageStub(name: "Jungle", price: "Number of Cards: 64", image: nil)
        ]
    }
}

private extension CollectionListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [CollectionController] = stubs.map { stub in
            let cellController = CardController(viewModel: stub.viewModel, delegate: stub, selection: { })
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
            controller?.display(ResourceErrorViewModel(message: .none))
            controller?.display(image)
        } else {
            controller?.display(ResourceErrorViewModel(message: "any"))
        }
    }
    
    func didCancelImageRequest() {
    }
}
