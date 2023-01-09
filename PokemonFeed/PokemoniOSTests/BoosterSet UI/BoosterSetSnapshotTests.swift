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
    func test_listWithContent() {
        
    }
    
    // MARK: - Helpers

    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.separatorStyle = .none
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
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
    
    init(viewModel: BoosterSetViewModel, image: UIImage?, controller: BoosterSetController? = nil) {
        self.viewModel = viewModel
        self.image = image
        self.controller = controller
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
