//
//  CollectionListViewController+Helpers.swift
//  PokemonTCGTests
//
//  Created by Marlon Ansale on 1/11/23.
//

import UIKit
import PokemoniOS

extension CollectionListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        collectionView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiatedReload() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return collectionView.refreshControl?.isRefreshing == true
    }
    
    private var cardsSection: Int { 0 }
}

extension CollectionListViewController {
    func numberOfRows(in section: Int) -> Int {
        collectionView.numberOfSections > 0 ? collectionView.numberOfItems(inSection: cardsSection) : 0
        
    }
    
    func numberOfRenderedCardViews() -> Int {
        numberOfRows(in: cardsSection)
    }
    
    @discardableResult
    func simulateBoosterSetViewVisible(at index: Int) -> CardCollectionCell? {
        return cardView(at: index) as? CardCollectionCell
    }
        
    func cardView(at row: Int) -> UICollectionViewCell? {
        collectionView.cellForItem(at: IndexPath(row: row, section: cardsSection))
    }
    
}
