//
//  BoosterSetController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/3/23.
//

import UIKit
import PokemonFeed

public final class BoosterSetController: NSObject {
    public typealias ResourceViewModel = UIImage
    
    private let viewModel: BoosterSetViewModel
    private let delegate: ImageControllerDelegate
    private var cell: BoosterSetCell?
    
    public init(viewModel: BoosterSetViewModel, delegate: ImageControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    private func requestImage() {
        delegate.didRequestImage()
    }
    
    private func cancel() {
        delegate.didCancelImageRequest()
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

extension BoosterSetController: UITableViewDataSource{
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

}

extension BoosterSetController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        requestImage()
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancel()
    }
}


extension BoosterSetController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: UIImage) {
        cell?.boosterSetImageView.image = viewModel
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        
    }
}
