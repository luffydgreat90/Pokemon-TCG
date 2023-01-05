//
//  CollectionListViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/5/23.
//

import UIKit

class CollectionListViewController: UICollectionViewController {

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CollectionController> = {
        .init(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
    }()
    
    public var onRefresh: (() -> Void)?
    
    /// Configure Cell and Layout.s
    public var configureCollectionView: ((UICollectionView) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI(){
        configureCollectionView?(collectionView)
    }

    public func display(_ cellControllers: [CollectionController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CollectionController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers, toSection: 0)
        dataSource.apply(snapshot)
    }


}
