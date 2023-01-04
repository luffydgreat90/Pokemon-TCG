//
//  CollectionController.swift
//  PokemoniOS
//
//  Created by Marlon Ansale on 1/4/23.
//

import UIKit

public struct CollectionController {
    let id: AnyHashable
    let dataSource: UICollectionViewDataSource
    let delegate: UICollectionViewDelegate?
    let dataSourcePrefetching: UICollectionViewDataSourcePrefetching?
    
    public init(id: AnyHashable, dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate?, dataSourcePrefetching: UICollectionViewDataSourcePrefetching?) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = delegate
        self.dataSourcePrefetching = dataSourcePrefetching
    }
}

extension CollectionController: Equatable {
    public static func == (lhs: CollectionController, rhs: CollectionController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CollectionController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
