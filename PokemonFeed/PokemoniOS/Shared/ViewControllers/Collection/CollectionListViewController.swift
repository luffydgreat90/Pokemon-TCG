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
            configureCollectionView?(collectionView)
            self.collectionView.dataSource = dataSource
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: 150, height: 150)
        }
}

extension CollectionListViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
       
    }
}

extension CollectionListViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {
    
    }
}
