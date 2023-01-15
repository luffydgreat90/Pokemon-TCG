//
//  LoadMoreCellController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/15/23.
//

import UIKit
import PokemonFeed

public class LoadMoreCellController: NSObject {
    private let cell = LoadMoreCell()
    private let callBack: () -> Void
    
    public init(callBack: @escaping () -> Void) {
        self.callBack = callBack
    }
}

extension LoadMoreCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          cell.selectionStyle = .none
          return cell
    }
}

extension LoadMoreCellController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        callBack()
    }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        cell.message = viewModel.message
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
}
