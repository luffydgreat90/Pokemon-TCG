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
        refreshControl?.simulatePullToRefresh()
    }
}
