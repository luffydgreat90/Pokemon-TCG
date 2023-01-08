//
//  CollectionListViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/5/23.
//

import UIKit
import PokemonFeed

public final class CollectionListViewController: UICollectionViewController {

    public let onRefresh: (() -> Void)?
    
    public init(
        collectionViewLayout layout: UICollectionViewLayout,
        onRefresh:(() -> Void)?,
        configureCollectionView: ((UICollectionView) -> Void)?
    ) {
        self.onRefresh = onRefresh
        super.init(collectionViewLayout: layout)
        self.collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.refreshControl = UIRefreshControl()
        configureCollectionView?(collectionView)
        self.collectionView.dataSource = dataSource
        self.collectionView.prefetchDataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CollectionController> = {
        .init(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
    }()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        onRefresh?()
    }

    public func display(_ cellControllers: [CollectionController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CollectionController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dsp = controller(for: indexPath)?.delegate
        dsp?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    
    private func controller(for indexPath: IndexPath) -> CollectionController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}

extension CollectionListViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

extension CollectionListViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        self.collectionView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

extension CollectionListViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
    
    }
}
