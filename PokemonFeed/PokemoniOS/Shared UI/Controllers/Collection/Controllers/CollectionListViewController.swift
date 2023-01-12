//
//  CollectionListViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/5/23.
//

import UIKit
import PokemonFeed

public final class CollectionListViewController: UICollectionViewController {

    public var onRefresh: (() -> Void)?
    public var configureCollectionView: ((UICollectionView) -> Void)?
    private let layout: UICollectionViewLayout
    
    public override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.layout = layout
        super.init(collectionViewLayout: layout)
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
        self.refresh()
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

private extension CollectionListViewController {
    func setupUI(){
        collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: self.layout)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = self
        
        configureCollectionView?(collectionView)
    }
    
   @objc func refresh(){
        onRefresh?()
    }
}

extension CollectionListViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = controller(for: indexPath)?.dataSourcePrefetching
            dsp?.collectionView?(collectionView, cancelPrefetchingForItemsAt: indexPaths)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = controller(for: indexPath)?.dataSourcePrefetching
            dsp?.collectionView?(collectionView, cancelPrefetchingForItemsAt: indexPaths)
        }
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


