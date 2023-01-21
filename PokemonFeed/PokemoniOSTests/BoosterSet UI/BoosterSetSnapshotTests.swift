//
//  BoosterSetSnapshotTests.swift
//  PokemoniOSTests
//
//  Created by Marlon Ansale on 1/9/23.
//

import XCTest
import PokemoniOS
@testable import PokemonFeed

final class BoosterSetSnapshotTests: XCTestCase {
    func test_boosterSetsWithImage() {
        let sut = makeSUT()
        
        sut.display(boosterSetsWithImage())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BOOSTER_SETS_WITH_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "BOOSTER_SETS_WITH_IMAGE_dark")
        
    }
    
    func test_boosterSetsWithoutImage() {
        let sut = makeSUT()
        
        sut.display(boosterSetsWithoutImage())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BOOSTER_SETS_WITHOUT_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "BOOSTER_SETS_WITHOUT_IMAGE_dark")
        
    }
    
    func test_boosterSetWithLoadMoreIndicator() {
        let sut = makeSUT()
        sut.display(boosterSetsWithLoadMoreIndicator())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BOOSTER_SETS_WITH_LOAD_MORE_INDICATOR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "BOOSTER_SETS_WITH_LOAD_MORE_INDICATOR_dark")
    }
    
    func test_boosterSetsWithLoadMoreError() {
        let sut = makeSUT()

        sut.display(boosterSetsWithLoadMoreError())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BOOSTER_SETS_LOAD_MORE_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "BOOSTER_SETS_LOAD_MORE_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "BOOSTER_SETS_LOAD_MORE_ERROR_extraExtraExtraLarge")
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.configureTableView = { tableView in
            tableView.register(BoosterSetCell.self)
        }
        controller.loadViewIfNeeded()
        controller.tableView.separatorStyle = .none
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    
    private func boosterSetsWithLoadMoreIndicator() -> [CellController] {
        let loadMore = LoadMoreCellController(callBack: {})
            loadMore.display(ResourceLoadingViewModel(isLoading: true))
            return boosterSetsWith(loadMore: loadMore)
    }
    
    private func boosterSetsWithLoadMoreError() -> [CellController] {
        let loadMore = LoadMoreCellController(callBack: {})
          loadMore.display(ResourceErrorViewModel(message: "This is a multiline\nerror message"))
          return boosterSetsWith(loadMore: loadMore)
      }
    
    private func boosterSetsWith(loadMore: LoadMoreCellController) -> [CellController] {
            let stub = boosterSetsWithImage().last!
            let cellController = BoosterSetController(viewModel: stub.viewModel, delegate: stub, selection: {})
            stub.controller = cellController

            return [
                CellController(id: UUID(), cellController),
                CellController(id: UUID(), loadMore)
            ]
        }
    
    private func boosterSetsWithImage() -> [ImageStub] {
        return [
            ImageStub(title: "Base", totalCards: "Number of Cards: 102", releaseDate: "Jan 09 1999", image: UIImage.make(withColor: .red)),
            ImageStub(title: "Jungle", totalCards: "Number of Cards: 64", releaseDate: "Jun 16 1999", image: UIImage.make(withColor: .green))
        ]
    }
    
    private func boosterSetsWithoutImage() -> [ImageStub] {
        return [
            ImageStub(title: "Base", totalCards: "Number of Cards: 102", releaseDate: "Jan 09 1999", image: nil),
            ImageStub(title: "Jungle", totalCards: "Number of Cards: 64", releaseDate: "Jun 16 1999", image: nil)
        ]
    }
    
}

private extension ListViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [CellController] = stubs.map { stub in
            let cellController = BoosterSetController(viewModel: stub.viewModel, delegate: stub, selection: {})
            stub.controller = cellController
            return CellController(id: UUID(), cellController)
        }

        display(cells)
    }
}

fileprivate class ImageStub: ImageControllerDelegate {
    
    let viewModel: BoosterSetViewModel
    let image: UIImage?
    weak var controller: BoosterSetController?
    
    init(title: String, totalCards: String, releaseDate: String, image: UIImage?) {
        self.viewModel = BoosterSetViewModel(title: title, totalCards: totalCards, releaseDate: releaseDate)
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
    
    func didCancelImageRequest() {}
}
