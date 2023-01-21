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
    private let frame: CGRect?
    
    private(set) public var errorView: ErrorView = ErrorView()
    
    public init(collectionViewLayout layout: UICollectionViewLayout, frame: CGRect? = nil) {
        self.layout = layout
        self.frame = frame
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
    
    public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dsp = controller(for: indexPath)?.delegate
        dsp?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
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
        collectionView = UICollectionView.init(frame: self.frame ?? self.view.frame, collectionViewLayout: self.layout)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = self
        configureCollectionView?(collectionView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
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
        collectionView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

extension CollectionListViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView.message = viewModel.message
    }
}


