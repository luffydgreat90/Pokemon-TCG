//
//  CardController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/4/23.
//

import UIKit
import PokemonFeed

public final class CardController: NSObject {
    public typealias ResourceViewModel = UIImage
    
    private let viewModel: CardViewModel
    private let delegate: ImageControllerDelegate
    private var cell: CardCollectionCell?
    
    public init(viewModel: CardViewModel, delegate: ImageControllerDelegate, cell: CardCollectionCell? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.cell = cell
    }
    
    private func cancel() {
        delegate.didCancelImageRequest()
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell?.cardImageView.image = nil
        cell = nil
    }
}

extension CardController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell?.titleLabel.text = viewModel.name
        cell?.priceLabel.text = viewModel.price
        cell?.cardImageView.image = nil
        delegate.didRequestImage()
        return cell!
    }
    
}

extension CardController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancel()
    }
}

extension CardController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: UIImage) {
        cell?.cardImageView.setImageAnimated(viewModel)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.cardImageView.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        
    }
}
