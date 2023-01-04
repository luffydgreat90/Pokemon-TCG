//
//  CollectionViewController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/4/23.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CollectionController> = {
        .init(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
    }()
    
    public var onRefresh: (() -> Void)?
    
    /// Configure Cell and Layout.s
    public var configureTableView: ((UICollectionView) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI(){
        configureTableView?(collectionView)
    }

    public func display(_ cellControllers: [CollectionController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CollectionController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers, toSection: 0)
        dataSource.apply(snapshot)
    }


}
