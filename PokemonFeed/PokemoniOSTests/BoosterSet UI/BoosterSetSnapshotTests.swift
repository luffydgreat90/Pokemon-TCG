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
    func test_boosterSetsWithContent() {
        let sut = makeSUT()

        sut.display(boosterSetsWithContent())

        record(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BOOSTER_SETS_WITH_CONTENT_light")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "BOOSTER_SETS_WITH_CONTENT_dark")
        record(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "BOOSTER_SETS_WITH_CONTENT_light_extraExtraExtraLarge")
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
    
    private func boosterSetsWithContent() -> [ImageStub] {
        return [
            ImageStub(title: "Base", totalCards: "Number of Cards: 102", releaseDate: "Jan 09 1999", image: UIImage.make(withColor: .red)),
            ImageStub(title: "Jungle", totalCards: "Number of Cards: 64", releaseDate: "Jun 16 1999", image: UIImage.make(withColor: .green))
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

private class ImageStub: ImageControllerDelegate {
    
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
            controller?.display(image)
            controller?.display(ResourceErrorViewModel(message: .none))
        } else {
            controller?.display(ResourceErrorViewModel(message: "any"))
        }
    }
    
    func didCancelImageRequest() {
        
    }
    
    
}
